//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Enrique Gongora on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    // MARK: - Variables
    let userController = UserController()
    let photoFetchQueue = OperationQueue()
    var operations: [String : Operation] = [:]
    var cache = Cache<String, Data>()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUser { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        let user = userController.users[indexPath.row]
        cell.user = user
        loadImages(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let key = user.name
        operations[key]?.cancel()
    }
    
    // MARK: - Functions
    func loadImages(cell: UserTableViewCell, indexPath: IndexPath) {
        let selectedUser = userController.users[indexPath.row]
        let key = selectedUser.name
        
        if let cachedData = cache.thumbnailValue(for: key) {
            let image = UIImage(data: cachedData)
            cell.userImageView.image = image
            return
        }
        
        let fetchImage = FetchPhotoOperation(user: selectedUser)
        let storeCacheData = BlockOperation {
            if let data = fetchImage.imageData {
                self.cache.thumbnailCache(value: data, for: key)
            }
        }
        
        let completionOperation = BlockOperation {
            defer { self.operations.removeValue(forKey: key) }
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                NSLog("Image received for cell")
                return
            }
            
            if let data = fetchImage.imageData {
                cell.userImageView.image = UIImage(data: data)
            }
        }
        
        storeCacheData.addDependency(fetchImage)
        completionOperation.addDependency(fetchImage)
        photoFetchQueue.addOperations([fetchImage, storeCacheData], waitUntilFinished: false)
        OperationQueue.main.addOperation(completionOperation)
        operations[key] = fetchImage
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            guard let userDetailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            userDetailVC.user = user
        }
    }
    
}
