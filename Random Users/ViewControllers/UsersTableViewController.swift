//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    let userContoller = UserController()
    let cache = Cache<URL, Data>()
    var operations = [URL : FetchPhotoOperation]()
    let photoFetchQueue = OperationQueue()
    let cancelQueue = DispatchQueue(label: "CancelOperationQueue")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userContoller.fetchUsers { (error) in
            if let error = error {
                print("Error loading users: \(error)")
                print("\(#file):L\(#line): Code failed inside \(#function)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userContoller.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let aUser = userContoller.users[indexPath.row]
        let fullName = "\(aUser.name.first) \(aUser.name.last)"
        cell.nameLabel.text = fullName
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userContoller.users[indexPath.row]
        let operation = operations[user.picture.large]
        cancelQueue.sync {
            operation?.cancel()
        }
        
    }
    
    // MARK: - Private
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let aUser = userContoller.users[indexPath.row]
        let imageURL = aUser.picture.large
        
        // Check if there is cached data
        if let cacheData = cache.value(key: imageURL),
            let image = UIImage(data: cacheData) {
            cell.iconImage.image = image
            return
        }
        
        let fetchPhotoOp = FetchPhotoOperation(user: aUser)
        
        // Start our fetch operation:
        let cacheOp = BlockOperation {
            guard let imageData = fetchPhotoOp.imageData else { return }
            self.cache.cache(value: imageData, key: imageURL)
        }
        
        let completionOp = BlockOperation {
            defer {
                self.operations.removeValue(forKey: aUser.picture.large)
            }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            
            guard let imageData = fetchPhotoOp.imageData else { return }
            cell.iconImage.image = UIImage(data: imageData)
        }
        
        cacheOp.addDependency(fetchPhotoOp)
        completionOp.addDependency(fetchPhotoOp)
        
        photoFetchQueue.addOperation(fetchPhotoOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[aUser.picture.large] = fetchPhotoOp
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let userDetailVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            userDetailVC.user = userContoller.users[indexPath.row]
        }
    }
    
}
