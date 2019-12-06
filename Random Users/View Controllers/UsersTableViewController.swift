//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_204 on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let userController = UserController()
    private let cache = Cache<User, Data>()
    private let largePhotoCache = Cache<User, Data>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [User: Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userController.fetchRandomUsers { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = userController.users.results[indexPath.row]
        
        if let data = cache.value(for: userReference) {
            cell.imageView?.image = UIImage(data: data)
            return
        }
    
        let thumbnailphotoFetchOperation = FetchPhotoOperation(photoReference: userReference.picture.thumbnail)
        let largephotoFetchOperation = FetchPhotoOperation(photoReference: userReference.picture.large)
        
        let cacheOP = BlockOperation {
            if let data = thumbnailphotoFetchOperation.imageData,
                let largeData = largephotoFetchOperation.imageData {
                self.cache.cache(value: data, key: userReference)
                self.largePhotoCache.cache(value: largeData, key: userReference)
            }
        }
        
        let completionOP = BlockOperation {
            defer { self.operations.removeValue(forKey: userReference) }
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("Reused Cell")
                return
            }
            if let data = thumbnailphotoFetchOperation.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        cacheOP.addDependency(thumbnailphotoFetchOperation)
        cacheOP.addDependency(largephotoFetchOperation)
        completionOP.addDependency(thumbnailphotoFetchOperation)
        
        photoFetchQueue.addOperation(thumbnailphotoFetchOperation)
        photoFetchQueue.addOperation(largephotoFetchOperation)
        photoFetchQueue.addOperation(cacheOP)
        OperationQueue.main.addOperation(completionOP)
        
        self.operations[userReference] = thumbnailphotoFetchOperation
    }
    
    private func fetchImageData(forItemAt indexPath: IndexPath) -> Data? {
        
        let userReference = userController.users.results[indexPath.row]
        var imageData: Data?
        if let data = largePhotoCache.value(for: userReference) {
            return data
        }
        
        let photoFetchOperation = FetchPhotoOperation(photoReference: userReference.picture.large)
        
        let cacheOP = BlockOperation {
            if let data = photoFetchOperation.imageData {
                imageData = data
            }
        }
        
        let completionOP = BlockOperation {
            defer { self.operations.removeValue(forKey: userReference) }
            if let data = photoFetchOperation.imageData {
                imageData = data
            }
        }
        
        cacheOP.addDependency(photoFetchOperation)
        completionOP.addDependency(photoFetchOperation)
        
        photoFetchQueue.addOperation(photoFetchOperation)
        photoFetchQueue.addOperation(cacheOP)
        OperationQueue.main.addOperation(completionOP)
        
        self.operations[userReference] = photoFetchOperation
        return imageData
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        loadImage(forCell: cell, forItemAt: indexPath)
        cell.user = userController.users.results[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = userController.users.results[indexPath.row]
        operations[userReference]?.cancel()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailVC = segue.destination as? UserDetailViewController {
            if segue.identifier == "ShowDetailUserSegue" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.user = userController.users.results[indexPath.row]
                    if let data = largePhotoCache.value(for: userController.users.results[indexPath.row]) {
                        detailVC.imageData = data
                    }
                }
            }
        }
    }
}
