//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Moses Robinson on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    let userController = UserController()
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var cache: Cache<String, [User.Images: UIImage]> = Cache()
    var currentOperations: [String: [User.Images: FetchImageOperation]] = [:]
    var fetchQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loadData(_ sender: Any) {
        
        userController.loadUsers { (users, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.users = users
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users?.count ?? 0
    }
    
    let reuseIdentifier = "userCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        let user = users?[indexPath.row]
        cell.nameLabel.text = user?.name.capitalized
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let user = users?[indexPath.row], let email = user.email else { return }
        
        if let image = cache.value(for: email) {
            
            cell.userImageView?.image = image[.large]
            
        } else {
            
            let imageOperation = FetchImageOperation(user: user)
            
            let operation = BlockOperation {
                
                guard let image = imageOperation.image else { return }
                
                self.cache.cache(value: [.large: image], for: email)
            }
            
            let unusedOperation = BlockOperation {
                
                guard let image = imageOperation.image else { return }
                
                if indexPath == self.tableView.indexPath(for: cell) {
                    
                    cell.userImageView?.image = image // keep getting optional error
                    
                }
            }
            
            operation.addDependency(imageOperation)
            unusedOperation.addDependency(imageOperation)
            fetchQueue.addOperations([imageOperation, operation], waitUntilFinished: false)
            currentOperations[email] = [.large: imageOperation]
            OperationQueue.main.addOperation(unusedOperation)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let user = users?[indexPath.row], let email = user.email else { return }
        
        currentOperations[email]?[.large]?.cancel()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! UserViewController
        guard let index = tableView.indexPathForSelectedRow else { return }
        destination.user = users?[index.row]
        
    }
    
    
}
