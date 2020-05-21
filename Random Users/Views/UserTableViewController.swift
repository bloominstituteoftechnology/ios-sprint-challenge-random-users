//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    let userController = UserController()
//    let photoFetchOp = FetchPhotoOperation(imageURL: <#URL#>)

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.fetchUsersFromServer { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.contactList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell()}

        let contact = userController.contactList[indexPath.row]
        cell.user = contact
        

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetialSegue" {
            if let detailVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                let contact = userController.contactList[indexPath.row]
                detailVC.user = contact
            }
        }
    }
    
    // MARK: - Image Functions and properities
    
    func fetchImages(of imageURL: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("No data returned from data task: \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("No image returned from response task: \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard error == nil else {
                print("Error fetching images: \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
            completion(.success(image))
        }.resume()
    }
    
    private var thumbnailCache = Cache<Int, UIImage>()
    private var photoFetchQueue = OperationQueue()
    private var fetchOperations: [Int: FetchPhotoOperation] = [:]
    
    private var largeImageCache = Cache<Int, UIImage>()
    private let largeImageFetchQueue = OperationQueue()
    private var largeImageFetchOp: [Int: FetchPhotoOperation] = [:]
    
    // Puts a thumbnail image to a users contact row
    private func putThumbnailImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        cell.indexPath = indexPath
        let indexPatchCached = cell.indexPath
        let thumbnailURL = userController.contactList[indexPatchCached.item].picture.thumbnail
        
        if let image = thumbnailCache.thumbnailPictureValue(for: indexPatchCached.item) {
            cell.thumbnailImageView.image = image
            return
        }
        
        let fetchPhotoOp = FetchPhotoOperation(imageURL: thumbnailURL)
        fetchOperations[indexPatchCached.item] = fetchPhotoOp
        
        let cachePhotoOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                self.thumbnailCache.thumbnailPictureCache(value: image, for: indexPatchCached.item)
            }
        }
        
        let putImageOp = BlockOperation {
            if indexPatchCached != cell.indexPath {
                return
            }
        }
        
        if let image = fetchPhotoOp.imageData {
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = image
            }
        }
        cachePhotoOp.addDependency(fetchPhotoOp)
        putImageOp.addDependency(putImageOp)
    }
    
    private func putLargeImage(forUserDetailViewController detailVC: UserDetailViewController, forItemAt indexPath: IndexPath) {
        let largeUrl = userController.contactList[indexPath.row].picture.large
        if let image = largeImageCache.largePictureValue(for: indexPath.item) {
            detailVC.largeImageView.image = image
            return
        }
        
        let fetchPhotoOp = FetchPhotoOperation(imageURL: largeUrl)
        fetchOperations[indexPath.item] = fetchPhotoOp
        
        let cachePhotoOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                self.largeImageCache.largPictureCache(value: image, for: indexPath.item)
            }
        }
        
        let putImageOp = BlockOperation {
            if let image = fetchPhotoOp.imageData {
                DispatchQueue.main.async {
                    detailVC.largeImageView.image = image
                }
            }
        }
        cachePhotoOp.addDependency(fetchPhotoOp)
        putImageOp.addDependency(putImageOp)
        largeImageFetchQueue.addOperations([cachePhotoOp, fetchPhotoOp, putImageOp], waitUntilFinished: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionView, forItemAt indexPath: IndexPath) {
        if let fetchImageOp = fetchOperations[indexPath.item] {
            fetchImageOp.cancel()
        }
    }
}
