//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

   private let controller = APIController()

    private var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    /// Caching Info (Thumbnail)
    private var thumbnailCache = Cache<Int, UIImage>()
    private var photoFetchQueue = OperationQueue()
    private var fetchOperations: [Int: FetchPhotoOperation] = [:]

    /// Caching Info (Large Photo)
    private var largePhotoCache = Cache<Int, UIImage>()
    private let largePhotoFetchQueue = OperationQueue()
    private var largePhotoFetchOperations: [Int: FetchPhotoOperation] = [:]


    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Person Cell", for: indexPath) as? PersonTableViewCell ?? PersonTableViewCell()

        cell.user = users[indexPath.item]
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }


    // MARK: - IBActions
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        controller.fetchRandomUsers { result in
            do {
                let users = try result.get()
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                if let error = error as? NetworkError {
                    print("Error retriving data \(error)")
                }
            }
        }
        self.tableView.reloadData()
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailVC = segue.destination as? DetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.person = users[indexPath.row]
                    loadImage(forDetailViewController: detailVC, forItemAt: indexPath)
                }
            }
        }
    }


    // MARK: - Functions
    
    // Thumbnail
    private func loadImage(forCell cell: PersonTableViewCell, forItemAt indexPath: IndexPath) {
        cell.indexPath = indexPath
        let indexPathCached = cell.indexPath

        let smallThumbnailURL = users[indexPathCached.item].picture.thumbnail

        if let image = thumbnailCache.value(for: indexPathCached.item) {
            cell.userPicture.image = image
            return
        }

        let fetchPhotoOp = FetchPhotoOperation(imageURL: URL(string: smallThumbnailURL)!)
        fetchOperations[indexPathCached.item] = fetchPhotoOp

        let cachePhotoOP = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                self.thumbnailCache.cache(value: image, for: indexPathCached.item)
            }
        }

        let setImageOP = BlockOperation {
            if indexPathCached != cell.indexPath {
                return
            }

            if let image = fetchPhotoOp.imageData {
                DispatchQueue.main.async {
                    cell.userPicture.image = image
                }
            }
        }
        cachePhotoOP.addDependency(fetchPhotoOp)
        setImageOP.addDependency(fetchPhotoOp)

        photoFetchQueue.addOperations([fetchPhotoOp, cachePhotoOP, setImageOP], waitUntilFinished: false)
    }

    // Large photo
    private func loadImage(forDetailViewController vc: DetailViewController, forItemAt indexPath: IndexPath) {

        let largePhotoURL = users[indexPath.item].picture.large

        if let image = largePhotoCache.value(for: indexPath.item) {
            print("large image Cached Image: \(indexPath.item)")
            vc.personImage.image = image
            return
        }

        let fetchPhotoOp = FetchPhotoOperation(imageURL: URL(string: largePhotoURL)!)
        largePhotoFetchOperations[indexPath.item] = fetchPhotoOp

        let cachePhotoOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                self.largePhotoCache.cache(value: image, for: indexPath.item)
            }
        }

        let setImageOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                DispatchQueue.main.async {
                    vc.personImage.image = image
                }
            }
        }
        cachePhotoOp.addDependency(fetchPhotoOp)
        setImageOp.addDependency(fetchPhotoOp)

        largePhotoFetchQueue.addOperations([fetchPhotoOp, cachePhotoOp, setImageOp], waitUntilFinished: false)
    }

    // Fetching Image
    private func fetchImage(of imageUrl: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {

        var request = URLRequest(url: imageUrl)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(.otherNetworkError))
                return
            }

            guard let data = data else {
                print("Error")
                completion(.failure(.badData))
                return
            }

            guard let image = UIImage(data: data) else {
                print("Error")
                completion(.failure(.badData))
                return
            }

            completion(.success(image))

        }.resume()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let fetchPhotoOperation = fetchOperations[indexPath.item] {
            fetchPhotoOperation.cancel()
        }
    }
}
