//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    // MARK: - Properties
    private let client = RandomUserClient()
    private let controller = RandomUserController()

    private var users = [User]() {
        didSet {
            DispatchQueue.main.async { self.tableView?.reloadData() }
        }
    }

    private var thumbnailCache = Cache<Int, UIImage>()
    private let photoFetchQueue = OperationQueue()
    private var fetchOperations: [Int: FetchPhotoOperation] = [:]

    private var largePhotoCache = Cache<Int, UIImage>()
    private let largePhotoFetchQueue = OperationQueue()
    private var largePhotoFetchOperations: [Int: FetchPhotoOperation] = [:]

    // MARK: - Outlets
    
    // MARK: - Actions
    @IBAction func loadButton(_ sender: UIBarButtonItem) {
        controller.fetchRandomUsers() { result in
            do {
                let users = try result.get()
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth:
                        NSLog("No auth")
                    case .badAuth:
                        NSLog("Token invalid")
                    case .otherNetworkError:
                        NSLog("Other error occurred, see log")
                    case .badData:
                        NSLog("No data received, or data corrupted")
                    case .noDecode:
                        NSLog("JSON could not be decoded")
                    case .badUrl:
                        NSLog("URL invalid")
                    }
                }
            }
        }
    }
    
    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell ?? PersonTableViewCell()
        
        cell.user = users[indexPath.item]
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewSegue" {
            if let personVC = segue.destination as? PersonViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    personVC.person = users[indexPath.row]
                    loadImage(forPersonViewController: personVC, forItemAt: indexPath)
                }
            }
        }
    }

    // MARK: - Private
    
    // For the thumbnail
    private func loadImage(forCell cell: PersonTableViewCell, forItemAt indexPath: IndexPath) {
        
        // Cache the indexPath for fetchImage completion to know whether cell has moved
        cell.originalIndexPath = indexPath
        let cachedIndexPath = cell.originalIndexPath
        
        // Which photo information do we need to load?
        let thumbnailURL = users[cachedIndexPath.item].picture.thumbnail

        // Is the image cached? ... avoiding a network lookup.
        if let image = thumbnailCache.value(for: cachedIndexPath.item) {
            print("thumbnail Cached Image: \(cachedIndexPath.item)")
            cell.thumbnailImageView.image = image
            return
        }
        
        // Don't have image. Need to retrieve it.
        // ---- Operation to grab photo ---------------------------
        let fetchPhotoOp = FetchPhotoOperation(imageURL: URL(string: thumbnailURL)!)
        fetchOperations[cachedIndexPath.item] = fetchPhotoOp
        
        // ---- Operation to cache photo --------------------------
        let cachePhotoOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                // TODO: ? Is this tread safe? Yes, because we're not going to a different thread.
                self.thumbnailCache.cache(value: image, for: cachedIndexPath.item)
            }
        }
        
        // ---- Operation to place photo in cell ------------------
        let setImageOp = BlockOperation {
            if cachedIndexPath != cell.originalIndexPath {
                // Cell was reused before image finished loading
                // print("\(cachedIndexPath) != \(cell.indexPath)")
                return
            }
                
            if let image = fetchPhotoOp.imageData {
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }
        }
        
        /// TODO: ? Do I need have an operation that removes FetchPhotoOperation from fetchOperations? And have 2 dependancies? setImageOp and cachePhotoOp. Or does overwriting it at a later time cause it to be garbage collected?
        
        cachePhotoOp.addDependency(fetchPhotoOp)
        setImageOp.addDependency(fetchPhotoOp)
        
        photoFetchQueue.addOperations([fetchPhotoOp, cachePhotoOp, setImageOp], waitUntilFinished: false)
    }
    
    // For the large photo
    private func loadImage(forPersonViewController vc: PersonViewController, forItemAt indexPath: IndexPath) {
        
        // Which photo information do we need to load?
        let largePhotoURL = users[indexPath.item].picture.large

        // Is the image cached? ... avoiding a network lookup.
        if let image = largePhotoCache.value(for: indexPath.item) {
            print("large image Cached Image: \(indexPath.item)")
            vc.largeImage = image
            return
        }
        
        // Don't have image. Need to retrieve it.
        // ---- Operation to grab photo ---------------------------
        let fetchPhotoOp = FetchPhotoOperation(imageURL: URL(string: largePhotoURL)!)
        largePhotoFetchOperations[indexPath.item] = fetchPhotoOp
        
        // ---- Operation to cache photo --------------------------
        let cachePhotoOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                // TODO: ? Is this tread safe? Yes, because we're not going to a different thread.
                self.largePhotoCache.cache(value: image, for: indexPath.item)
            }
        }
        
        // ---- Operation to place photo in cell ------------------
        let setImageOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                DispatchQueue.main.async {
                    vc.largeImage = image
                }
            }
        }
        
        cachePhotoOp.addDependency(fetchPhotoOp)
        setImageOp.addDependency(fetchPhotoOp)
        
        largePhotoFetchQueue.addOperations([fetchPhotoOp, cachePhotoOp, setImageOp], waitUntilFinished: false)
    }

    /// Fetch an image from the Internet via a URL
    /// - Parameters:
    ///   - imageUrl: A secure URL to the image you want to load
    ///   - completion: What do you want done with the downloaded image?
    private func fetchImage(of imageUrl: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        var request = URLRequest(url: imageUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving mars image data: \(error)")
                completion(.failure(.otherNetworkError))
                return
            }
            
            guard let data = data else {
                NSLog("nasa.gov responded with no image data.")
                completion(.failure(.badData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Image data is incomplete or corrupt.")
                completion(.failure(.badData))
                return
            }

            completion(.success(image))

        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // What photo were we trying to load
// FIXME: Is this an issue I'm just using indexPath.item?      let photoReference = photoReferences[indexPath.item]

        if let fetchPhotoOperation = fetchOperations[indexPath.item] {
            // A photo is trying to be loaded.
            fetchPhotoOperation.cancel()
        }
    }}
