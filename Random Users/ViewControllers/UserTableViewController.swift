//
//  UserTableViewController.swift
//  Random Users
//
//  Created by De MicheliStefano on 07.09.18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    // MARK: - Properties
    var users: [User] = []
    var userImages: [String : Data] = [:]
    var userClient = UserClient()
    private var cache = Cache<String, User>()
    private var imageOperationQueue = OperationQueue()
    private var imageFetchOperations: [String : ImageFetchOperation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        userClient.fetchUsers() { users, error in
            if let error = error {
                NSLog("Error fetching data from network: \(error)")
                return
            }
            
            guard let users = users else {
                NSLog("Error loading users")
                return
            }
            
            DispatchQueue.main.async {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell

        loadImage(for: cell, atIndexPath: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let fetchOperation = imageFetchOperations[user.id]
        fetchOperation?.cancel()
    }

    // MARK: - Private methods
    
    private func loadImage(for cell: UserTableViewCell, atIndexPath indexPath: IndexPath) {
        var user = users[indexPath.row]
        
        if let cachedUser = cache.value(for: user.id) {
            cell.nameTextLabel?.text = cachedUser.name
            if let picture = cachedUser.picture {
                cell.userImageView?.image = UIImage(data: picture)
            }
            return
        }
        
        let fetchOperation = ImageFetchOperation(with: user)
        imageFetchOperations[user.id] = fetchOperation
        
        let cacheOperation = BlockOperation {
            if let image = fetchOperation.imageData {
                self.userImages[user.id] = image
            }
            self.cache.cache(for: user.id, with: user)
        }
        
        let updateUIOperation = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                NSLog("Cell instance has been reused for a different indexPath")
                return
            }
            
            if let image = fetchOperation.imageData {
                user.picture = image
                cell.userImageView?.image = UIImage(data: image)
            }
            cell.nameTextLabel?.text = user.name
        }
        
        cacheOperation.addDependency(fetchOperation)
        updateUIOperation.addDependency(fetchOperation)
        
        imageOperationQueue.addOperation(fetchOperation)
        imageOperationQueue.addOperation(cacheOperation)
        OperationQueue.main.addOperation(updateUIOperation)
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            let detailVC = segue.destination as! UserDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            detailVC.user = user
            detailVC.userImage = userImages[user.id]
        }
    }

}
