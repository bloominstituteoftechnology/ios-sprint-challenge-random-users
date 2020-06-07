//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    private let controller = APIController()
    private let imageFetchQueue = OperationQueue()
    private let thumbnailCache = Cache<String, Data>()
    private let operationDict: [String : ImageFetchOperation] = [:]

    var users: [User] = [] {
        didSet {
            asyncReload()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userEmail = users[indexPath.row].email
        
        operationDict[userEmail]?.cancel()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "showUserDetail":
            guard let userDetailViewController = segue.destination as? UserDetailViewController else {
                NSLog("Unexpected destination: \(segue.destination)")
                return
            }
            
            guard let selectedViewCell = sender as? UserViewCell else {
                NSLog("Unexpected sender: \(sender ?? "No sender available")")
                return
            }
            
            guard let indexPath = tableView.indexPath(for: selectedViewCell) else {
                NSLog("The selected cell is not being displayed by the table")
                return
            }
            
            let selectedUser = users[indexPath.row]
            
            userDetailViewController.user = selectedUser
        default:
            NSLog("Unexpected segue indentifier: \(segue.identifier ?? "No segue available")")
            return
        }
    }
    
    // MARK: - Util functions
    private func getUsers() {
        controller.getUsersFromAPI { result in
            do {
                let userResults = try result.get()
                DispatchQueue.main.async {
                    self.users = userResults.users
                }
            } catch {
                NSLog("Error fetching users. Logging function called from UsersTableViewController")
                return
            }
        }
    }
    
    private func asyncReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
