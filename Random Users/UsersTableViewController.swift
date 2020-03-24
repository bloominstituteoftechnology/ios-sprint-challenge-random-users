//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Christy Hicks on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: Properties
    let userController = UserController()
    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    private let fetchQueue = OperationQueue()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userController.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        self.loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
       override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let userReference = self.userController.users[indexPath.item]
         operations[userReference.name]?.cancel()
     }
    // MARK: Methods
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let userReference = self.userController.users[indexPath.item]
        
        if let cachedData = self.cache.value(for: userReference.name),
            let image = UIImage(data: cachedData) {
            cell.imageView?.image = image
            cell.textLabel?.text = userReference.name
            return
        }
        
        let fetchUserOperation = FetchContactOperation(user: userReference)
        let cachedOperation = BlockOperation {
            if let data = fetchUserOperation.imageData {
                self.cache.cache(value: data, for: userReference.name)
            }
        }
        
        let checkOperation = BlockOperation {
            defer { self.operations.removeValue(forKey: userReference.name) }
            
            if let activeIndexPath = self.tableView?.indexPath(for: cell),
                activeIndexPath != indexPath {
                return
            }
            
            if let imageData = fetchUserOperation.imageData {
                cell.imageView?.image = UIImage(data: imageData)
                cell.textLabel?.text = userReference.name
            }
        }
        cachedOperation.addDependency(fetchUserOperation)
        checkOperation.addDependency(fetchUserOperation)
        fetchQueue.addOperation(fetchUserOperation)
        fetchQueue.addOperation(cachedOperation)
        OperationQueue.main.addOperation(checkOperation)
        
        self.operations[userReference.name] = fetchUserOperation
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let userDetailVC = segue.destination as? DetailViewController,
                let indexPath = self.tableView.indexPathForSelectedRow else { return }
            userDetailVC.user = self.userController.users[indexPath.row]
        }
    }
}
