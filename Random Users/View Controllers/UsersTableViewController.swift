//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Bobby Keffury on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var userController = UserController()
    var userDetailViewController = UserDetailViewController()
    var user: User?
    var users: [User] = []
    private let cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [String : Operation]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }

        let user = self.users[indexPath.row]
        cell.user = user
        loadImage(forCell: cell, forItemAt: indexPath)
        
        
        return cell
    }
    
    
    
    @IBAction func searchUsersTapped(_ sender: Any) {
        userController.searchForUsers { (result) in
            DispatchQueue.main.async {
                do {
                    let result = try result.get()
                    self.users = result.results
                    self.tableView.reloadData()
                    
                } catch {
                    print("Error getting result: \(error)")
                }
            }
        }
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        
        
        if let value = cache.value(for: user.name.first), let photo = UIImage(data: value) {
            cell.imageView?.image = photo
        }
        
        let fetchOp = FetchPhotoOperation(user: user)
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, for: user.name.first)
            }
        }
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: user.name.first) }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return // Cell has been reused
                }
                
                if let data = fetchOp.imageData {
                    cell.imageView?.image = UIImage(data: data)
                }
            }
        }
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[user.name.first] = fetchOp
        
       }
    

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailShowSegue" {
            if let detailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                detailVC.user = users[indexPath.row]
                
            }
        }
    }
    

}
