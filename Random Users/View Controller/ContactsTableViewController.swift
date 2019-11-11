//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Fabiola S on 11/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    let userController = UserController()
    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    private let fetchQueue = OperationQueue()

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


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)

        self.loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
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
        
        override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let userReference = self.userController.users[indexPath.item]
            operations[userReference.name]?.cancel()
        }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetailSegue" {
            guard let userDetailVC = segue.destination as? ContactDetailViewController,
                let indexPath = self.tableView.indexPathForSelectedRow else { return }
            userDetailVC.user = self.userController.users[indexPath.row]
        }
    }


}
