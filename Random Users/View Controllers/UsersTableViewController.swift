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
    let imageCache = Cache<String, UIImage>()

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
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
         let userReference = users[indexPath.item]
        
        // Checking if image is already in cache
        if let cache = imageCache.value(for: userReference.email) {
            cell.userThumbnailImage.image = cache
            return
        } else {
            
            // TODO: Implement image loading here
            let fetchPhotoOperation = FetchImageOperation(user: userReference)
            
            let photoDataCacheOperation = BlockOperation {
                if let imageData = fetchPhotoOperation.imageData {
                    guard let image: UIImage = UIImage(data: imageData) else { return }
                    self.imageCache.cache(value: image, for: userReference.email)
                }
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
            
            photoFetchQueue.addOperations([fetchPhotoOperation, photoDataCacheOperation, cellStatus], waitUntilFinished: false)
            
            dictionaryFetchOperations[userReference.email] = fetchPhotoOperation
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
