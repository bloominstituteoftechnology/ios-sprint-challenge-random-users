//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Hayden Hastings on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let userController = UserController()
    private var cache: Cache<String, UIImage> = Cache()
    private let fetchPhotoQueue = OperationQueue()
    private var operations: [String : FetchThumbnailOperation] = [:]
    
    // MARK: - IBActions
    
    @IBAction func add(_ sender: Any) {
        userController.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userController.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersTableViewCell
        
        let randomUser = userController.users[indexPath.row]
        cell.textLabel?.text = randomUser.name
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if userController.users.count > 0 {
            let user = userController.users[indexPath.row]
            operations[user.email]?.cancel()
        } else {
            for (_, operation) in operations {
                operation.cancel()
            }
        }
    }
    
    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        
        let randomUser = userController.users[indexPath.row]
        
        if let image = cache.value(for: randomUser.email) {
            cell.imageView?.image = image
        } else {
            let fetchOp = FetchThumbnailOperation(user: randomUser)
            
            let cacheOp = BlockOperation {
                guard let image = fetchOp.image else { return }
                self.cache.cache(value: image, key: randomUser.email)
            }
            
            
            let reuseCellOp = BlockOperation {
                guard let image = fetchOp.image else { return }
                
                if self.tableView.indexPath(for: cell) == indexPath {
                    cell.imageView?.image = image
                    self.tableView.reloadData()
                }
            }
            
            cacheOp.addDependency(fetchOp)
            reuseCellOp.addDependency(fetchOp)
            
            fetchPhotoQueue.addOperations([fetchOp, cacheOp], waitUntilFinished: false)
            OperationQueue.main.addOperation(reuseCellOp)
            
            operations[randomUser.email] = fetchOp
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToUserDetailVC" {
            guard let toDetailVC = segue.destination as? UserDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            toDetailVC.userController = userController
            toDetailVC.user = user
        }
    }
}







