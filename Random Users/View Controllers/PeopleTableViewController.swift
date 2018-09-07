//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Linh Bouniol on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    var userController = UserController()
    
    private var thumbnailCache: Cache<String, UIImage> = Cache()
    private var largeImageCache: Cache<String, UIImage> = Cache()
    
    private var photoFetchQueue = OperationQueue()
    private var fetchOperationDictionary: [String : PhotoFetchOperation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.getUsers { (error) in
            if let error = error {
                NSLog("Error getting user data from server: \(error)")
                return
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        let user = userController.users[indexPath.row]
        cell.textLabel?.text = user.name.capitalized
        cell.imageView?.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        
        // use the loadImage func to get images
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        
        guard let url = user.pictures["thumbnail"] else { return }
        let name = user.name
        
        if let image = thumbnailCache.value(for: name) {
            cell.imageView?.image = image
            cell.setNeedsLayout()

        } else {
            let photoFetchOperation = PhotoFetchOperation(url: url)
            let storeInCacheOperation = BlockOperation { [weak self] in
                guard let data = photoFetchOperation.pictureData else { return }
                guard let image = UIImage(data: data) else { return }
                self?.thumbnailCache.cache(value: image, for: name)
            }
            let updateCellOperation = BlockOperation { [weak self] in
                guard let image = self?.thumbnailCache.value(for: name) else { return }
                
                if let currentIndexPath = self?.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
            
            storeInCacheOperation.addDependency(photoFetchOperation)
            updateCellOperation.addDependency(storeInCacheOperation)
            
            photoFetchQueue.addOperations([photoFetchOperation, storeInCacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(updateCellOperation)
            
            // saving this fetchPhotoOperation to the dictionary with the id key
            fetchOperationDictionary[name] = photoFetchOperation
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? PeopleDetailViewController {
            detailVC.userController = userController
            detailVC.photoFetchQueue = photoFetchQueue
            detailVC.largeImageCache = largeImageCache
            
            if segue.identifier == "ShowDetail" {
                guard let index = tableView.indexPathForSelectedRow?.row else { return }
                let user = userController.users[index]
                detailVC.user = user
            }
        }
    }
}
