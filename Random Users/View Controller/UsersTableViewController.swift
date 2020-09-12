//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Norlan Tibanear on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    var userController = UserController()
    var users: [UserResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let cache = Cache<String, Data>()
    private let imageQueue = OperationQueue()
    var operation = [String: Operation]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.getUsers { (results) in
            do {
                let users = try results.get()
                DispatchQueue.main.async {
                    self.users = users.results
                }
            } catch {
                print(results)
            }
        }
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        updateCell(forCell: cell, forItemAt: indexPath)
        
        return cell
        
    }
    
    
    func updateCell(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        cell.usernameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        
        if let cacheData = cache.value(for: user.email),
            let image = UIImage(data: cacheData) {
            cell.userImageView.image = image
            return
        }
        
        let fetchImageOperation = FetchImageOperation(user: user)
        let store = BlockOperation {
            guard let data = fetchImageOperation.imageData else { return }
            self.cache.cache(value: data, for: user.email)
        }
        
        let isReused = BlockOperation {
            guard let data = fetchImageOperation.imageData else { return }
            cell.userImageView.image = UIImage(data: data)
        }
        
        store.addDependency(fetchImageOperation)
        isReused.addDependency(fetchImageOperation)
        
        imageQueue.addOperation(fetchImageOperation)
        imageQueue.addOperation(store)
        
        OperationQueue.main.addOperation(isReused)
        operation[user.email] = fetchImageOperation
        
        
    } // updateCell
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentOperation = users[indexPath.row]
        guard let newOperation = operation[currentOperation.email] else { return }
        newOperation.cancel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUserDetailVCSegue" {
            if let detailVC = segue.destination as? UserDetailVC,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.userController = userController
                detailVC.user = users[indexPath.row]
            }
        }
    }
   

} // Class
