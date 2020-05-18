//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    let userController = UserController()
    private let photoFetchQueue = OperationQueue()
    var dictionaryFetchOperations: [String : Operation] = [:]
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let imageCache = Cache<String, Data>()

    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers { (results) in
            do {
                let users = try results.get()
                DispatchQueue.main.async {
                    self.users = users.results
                }
            } catch {
                NSLog("Error fetching results")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userReference = users[indexPath.row]
        guard let currentOperation = dictionaryFetchOperations[userReference.email] else { return }
        currentOperation.cancel()
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
         let user = users[indexPath.row]
        
        cell.nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        
        // Checking if image is already in cache
        if let cache = imageCache.value(for: user.email),
            let image = UIImage(data: cache) {
            cell.userThumbnailImage.image = image
            return
        } else {
            
            // TODO: Implement image loading here
            let fetchPhotoOperation = FetchImageOperation(user: user)
            
            let photoDataCacheOperation = BlockOperation {
                guard let data = fetchPhotoOperation.imageData else { return }
                self.imageCache.cache(value: data, for: user.email)
            }
            
            let isCellReused = BlockOperation {
                guard let data = fetchPhotoOperation.imageData else { return }
                cell.userThumbnailImage.image = UIImage(data: data)
            }
            
            let cellStatus = BlockOperation {
                DispatchQueue.main.async {
                    if self.tableView.cellForRow(at: indexPath) == cell {
                        guard let imageData = fetchPhotoOperation.imageData else { return }
                        cell.userThumbnailImage.image = UIImage(data: imageData)
                    } else {
                        return
                    }
                }
            }
            
            photoDataCacheOperation.addDependency(fetchPhotoOperation)
            cellStatus.addDependency(fetchPhotoOperation)
            isCellReused.addDependency(fetchPhotoOperation)
            
            photoFetchQueue.addOperations([fetchPhotoOperation, photoDataCacheOperation, isCellReused, cellStatus], waitUntilFinished: false)
            dictionaryFetchOperations[user.email] = fetchPhotoOperation
        }
        
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! DetailViewController
                detailVC.userDetail = users[indexPath.row]
            }
        }
    }

}
