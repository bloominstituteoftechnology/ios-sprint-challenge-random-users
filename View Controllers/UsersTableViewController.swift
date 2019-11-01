//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by macbook on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: Properties
    var usersController = UsersController()
    var userTableViewCell = UserTableViewCell()
    private let photoFetchQueue = OperationQueue()
    let cache = Cache<Int, Data>()
    private var operations = [Int: Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        usersController.fetchUsers { (users, error) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersController.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let user = usersController.users[indexPath.row]
        let userName = "\(user.name.first) \(user.name.last)"
        cell.nameLabel.text = userName
        
        
        
        let imageURL = user.picture.thumbnail
        let cellKey = indexPath.row
        
        if let cachedData = cache.value(key: cellKey),
            let image = UIImage(data: cachedData) {
            cell.userImage.image = image
            return cell
        }
        
        let fetchOp = FetchPhotoOperation(user: user)
        
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, key: cellKey)
            }
        }
        
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: cellKey) }

            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            if let data = fetchOp.imageData {
                cell.userImage.image = UIImage(data: data)
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[cellKey] = fetchOp
        
        return cell
    }
  
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetailsSegue" {
            if let detailVC = segue.destination as? UserDetailsViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                detailVC.user = usersController.users[indexPath.row]
            }
        }
    }
}
