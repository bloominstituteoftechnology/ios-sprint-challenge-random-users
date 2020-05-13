//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var userController = UserController()
    let cache = Cache<String, Data>()
    private let queue = OperationQueue()
    private var operations = [String : Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchRandomUser { users in
            
            do {
                let users = try users.get()
                DispatchQueue.main.async {
                    self.users = users
                }
                
            } catch {
                
                if let error = error as? NetworkError {
                    NSLog("Error in retrieving users: \(error)")
                    return
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        guard let user = users?[indexPath.row] else { return cell }
        cell.userNameLabel.text = user.name
        
        
            self.loadImage(forCell: cell, forItemAt: indexPath)
       
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row],
            let email = user.email else { return }
        
        operations[email]?.cancel()
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let user = users?[indexPath.row],
            let email = user.email else { return }
        
        // Check for an image in cache
        if let cachedImageData = cache.value(key: email) {
            cell.userImageView.image = UIImage(data: cachedImageData)
        } else {
            let fetchOperation = FetchImageOperation(user: user)
            let cacheOperation = BlockOperation {
                guard let data = fetchOperation.imageData else { return }
                self.cache.cache(key: email, value: data)
            }
            
            // Download Image/Information
            let completionOperation = BlockOperation {
                defer { self.operations.removeValue(forKey: email) }
                
                if let data = fetchOperation.imageData {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                         cell.userNameLabel.text = user.name
                    }
                }
            }
            
            cacheOperation.addDependency(fetchOperation)
            completionOperation.addDependency(fetchOperation)
            queue.addOperations([cacheOperation, completionOperation, fetchOperation], waitUntilFinished: false)
            
            operations[email] = fetchOperation
            
        }
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            let usersDetailVC = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow?.row else { return }
            usersDetailVC.user = users![indexPath]
        }
    }
}
