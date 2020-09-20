//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by ronald huston jr on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    //  MARK: - properties
    let userClient = UserClient()
    
    let cache = Cache<String, Data>()
    let queue = OperationQueue()
    var operations = [String : Operation]()
    
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userClient.fetchUsers { (users, error) in
            if let error = error {
                print("error performing data task: \(error)")
                return
            }
            self.users = users
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        guard let user = users?[indexPath.row] else { return cell }
        cell.nameLabel.text = user.name
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row],
            let email = user.email else { return }
        
        operations[email]?.cancel()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetail" {
            guard let detail = segue.destination as? UserDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else {return}
            detail.user = users?[indexPath.row]
        }
    }


    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row],
            let email = user.email else { return }
        
        if let data = cache.value(key: email) {
            cell.userImageView?.image = UIImage(data: data)
            
        } else {
            let fetchOperation = FetchImageOperation(userRandom: user)
            let cacheOperation = BlockOperation {
                guard let data = fetchOperation.imageData else { return }
                self.cache.cache(key: email, value: data)
            }
            
            let displayImageOperation = BlockOperation {
                defer { self.operations.removeValue(forKey: email)}
                
                if let data = fetchOperation.imageData {
                    cell.userImageView.image = UIImage(data: data)
                    cell.nameLabel?.text = user.name
                }
            }
            queue.addOperation(fetchOperation)
            queue.addOperation(cacheOperation)
            cacheOperation.addDependency(fetchOperation)
            displayImageOperation.addDependency(fetchOperation)
            OperationQueue.main.addOperation(displayImageOperation)
            
            operations[email] = fetchOperation
        }
    }
}
