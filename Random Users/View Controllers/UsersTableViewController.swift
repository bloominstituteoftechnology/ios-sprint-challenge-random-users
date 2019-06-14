//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Mitchell Budge on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    // MARK: - View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers()
        DispatchQueue.main.async {
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
        cell.textLabel?.text = user.name
        loadThumbnail(for: cell, forItemAt: indexPath)
        return cell
    }
    
    // MARK: - Methods
    
    func loadThumbnail(for cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        if let cachedThumbnail = cache.value(for: user.email) {
            cell.imageView?.image = cachedThumbnail
        } else {
            let fetchThumbnailOperation = FetchThumbnailPhotoOperation(user: user)
            let cacheOperation = BlockOperation {
                if let data = fetchThumbnailOperation.thumbnailImage {
                    self.cache.cache(value: data, for: user.email)
                }
            }
            let checkReuseOperation = BlockOperation {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath { return }
            }
            if let data = fetchThumbnailOperation.thumbnailImage {
                cell.imageView?.image = data
            }
            cacheOperation.addDependency(fetchThumbnailOperation)
            checkReuseOperation.addDependency(fetchThumbnailOperation)
            photoFetchQueue.addOperations([fetchThumbnailOperation, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(checkReuseOperation)
            fetchedOperations[user.email] = fetchThumbnailOperation
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let userDetailVC = segue.destination as? UserDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            userDetailVC.userController = userController
            userDetailVC.user = user
        }
    }
    
    // MARK: - Properties
    let userController = UserController()
    let photoFetchQueue = OperationQueue()
    var fetchedOperations: [String : FetchThumbnailPhotoOperation] = [:]
    private let cache = Cache<String, UIImage>()

}
