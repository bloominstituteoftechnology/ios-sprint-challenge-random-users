//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jason Modisett on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    

    // MARK:- View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.frame = parent?.view.frame ?? view.frame
        activityIndicator.backgroundColor = .white
        activityIndicator.activityIndicatorViewStyle = .white
        activityIndicator.tintColor = .lightGray
        activityIndicator.startAnimating()
        parent?.view.addSubview(activityIndicator)
        
        tableView.alpha = 0
        
        userController.getUsersFromAPI { _ in
            UI {
                self.tableView.reloadData()
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.alpha = 1
                    activityIndicator.alpha = 0
                })
            }
        }
    }
    

    // MARK:- Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let user = userController.users[indexPath.row]
        cell.user = user
        fetchImage(for: cell, at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        
        if let operation = operations[user.picture.medium] {
            operation.cancel()
            operations.removeValue(forKey: user.picture.medium)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK:- User image fetching method
    private func fetchImage(for cell: UserTableViewCell, at indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        
        if let imageData = imageDataCache.value(for: user.picture.medium),
                tableView.cellForRow(at: indexPath) === cell {
            let userImage = UIImage(data: imageData)
            cell.userImage = userImage
            return
        }
        
        // Fetch operation
        let fetchOperation = FetchImageOperation(url: user.picture.medium)
        
        // Cache operation
        let cacheOperation = BlockOperation {
            if let imageData = fetchOperation.imageData {
                self.imageDataCache.cache(value: imageData, for: user.picture.medium)
            }
        }
        
        // UI update on main thread operation
        let updateCellOperation = BlockOperation {
            if let imageData = fetchOperation.imageData {
                let userImage = UIImage(data: imageData)
                cell.userImage = userImage
            }
        }
        
        // Dependancies
        cacheOperation.addDependency(fetchOperation)
        updateCellOperation.addDependency(fetchOperation)
        
        operations[user.picture.medium] = fetchOperation
        
        operationQueue.addOperation(fetchOperation)
        operationQueue.addOperation(cacheOperation)
        OperationQueue.main.addOperation(updateCellOperation)
    }
    

    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            guard let destVC = segue.destination as? UserDetailsViewController,
                  let index = tableView.indexPathForSelectedRow?.row else { return }
            destVC.user = userController.users[index]
        }
    }
    
    
    // MARK:- Properties & types
    private let userController = UserController()
    private let imageDataCache = Cache<String, Data>()
    private var operationQueue = OperationQueue()
    private var operations: [String: FetchImageOperation] = [:]
    
}
