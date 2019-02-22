//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addUsers(_ sender: Any) {
        
        usersController.fetchUsers(resultsNumber: "1000") { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersController.users.count
    }
    
    let reuseIdentifier = "UserCell"

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let user = usersController.users[indexPath.row]
        
        cell.textLabel?.text = user.name
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let user = usersController.users[indexPath.row]
        
        storedFetchedOperations[user.phone]?.cancel()
    }
    
    // MARK: - Private
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = usersController.users[indexPath.row]
        
        if let image = cache.value(for: user.phone) {
            
            cell.imageView?.image = image
        } else {
            
            let fetchPhotoOperation = FetchPhotoOperation(user: user)
            
            let cacheOperation = BlockOperation {
                guard let image = fetchPhotoOperation.image else { return }
                
                self.cache.cache(value: image, for: user.phone)
            }
            
            let cellReusedOperation = BlockOperation {
                guard let image = fetchPhotoOperation.image else { return }
                
                if self.tableView.indexPath(for: cell) == indexPath {
                    cell.imageView?.image = image
                    self.tableView.reloadData()
                }
            }
            
            cacheOperation.addDependency(fetchPhotoOperation)
            cellReusedOperation.addDependency(fetchPhotoOperation)
            
            photoFetchQueue.addOperations([fetchPhotoOperation, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(cellReusedOperation)
            
            storedFetchedOperations[user.phone] = fetchPhotoOperation
        }
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            guard let destination = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let user = usersController.users[indexPath.row]
            
            destination.userController = usersController
            destination.user = user
        }
    }
    
    // MARK: - Properties
    
    private var storedFetchedOperations: [String : FetchPhotoOperation] = [:]
    
    private let photoFetchQueue = OperationQueue()
    
    private var cache: Cache<String, UIImage> = Cache()

    let usersController = ModelClient()
}
