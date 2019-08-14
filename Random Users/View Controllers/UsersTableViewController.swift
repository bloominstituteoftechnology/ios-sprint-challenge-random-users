//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Michael Stoffer on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    let userController = UserController()
    
    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    private let userFetchQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userController.fetchUsers { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        self.loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userRef = self.userController.users[indexPath.item]
        operations[userRef.name]?.cancel()
    }
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let userReference = self.userController.users[indexPath.item]
        
        if let cachedData = self.cache.value(for: userReference.name),
            let image = UIImage(data: cachedData) {
            cell.imageView?.image = image
            cell.textLabel?.text = userReference.name
            return
        }
        
        let fetchUserOperation = FetchUserOperation(user: userReference)
        let cachedOperation = BlockOperation {
            if let data = fetchUserOperation.imageData {
                self.cache.cache(value: data, for: userReference.name)
            }
        }
        
        let checkReuseOperation = BlockOperation {
            defer { self.operations.removeValue(forKey: userReference.name) }
            
            if let currentIndexPath = self.tableView?.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            if let imageData = fetchUserOperation.imageData {
                cell.imageView?.image = UIImage(data: imageData)
                cell.textLabel?.text = userReference.name
            }
        }
        
        cachedOperation.addDependency(fetchUserOperation)
        checkReuseOperation.addDependency(fetchUserOperation)
        
        userFetchQueue.addOperation(fetchUserOperation)
        userFetchQueue.addOperation(cachedOperation)
        OperationQueue.main.addOperation(checkReuseOperation)
        
        self.operations[userReference.name] = fetchUserOperation
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailView" {
            guard let userDVC = segue.destination as? UserDetailViewController,
                let indexPath = self.tableView.indexPathForSelectedRow else { return }
            
            userDVC.user = self.userController.users[indexPath.row]
        }
    }
}
