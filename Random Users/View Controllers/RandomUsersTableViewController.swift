//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    var user: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var userController = UserController()
    let cache = Cache<User, UIImage>()
    private let queue = OperationQueue()
    private var operations = [User : Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchRandomUser { (error) in
            if let error = error {
                NSLog("Error fetching info for user: \(error)")
                return
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell ?? UserTableViewCell()
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        cell.user = user![indexPath.row]
        
        
        return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let user = user?[indexPath.row] else { return }
        
        // Check for an image in cache
        if let cachedImageData = cache.value(for: user) {
            cell.userImage.image = cachedImageData
            return
        }
        
        // Start an operation to fetch image data
        let fetchOperation = FetchUserOperation(user: user)
        let cacheOperation = BlockOperation {
            if let data = fetchOperation.imageData {
                self.cache.cache(value: data, for: user)
            }
        }
        
        let completionOperation = BlockOperation {
            defer { self.operations.removeValue(forKey: user) }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath == indexPath {
                return
            }
            
            if let data = fetchOperation.imageData {
                cell.userImage.image = UIImage(data: data)
            }
        }
        
        cacheOperation.addDependency(fetchOperation)
        completionOperation.addDependency(fetchOperation)
        queue.addOperation(fetchOperation)
        queue.addOperation(cacheOperation)
        
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            let usersDetailVC = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow?.row else { return }
            usersDetailVC.user = user![indexPath]
        }
    }
    
    
}
