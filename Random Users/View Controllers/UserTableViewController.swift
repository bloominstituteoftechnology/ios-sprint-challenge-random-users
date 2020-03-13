//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Enrique Gongora on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    // MARK: - Variables
    let userController = UserController()
    let photoFetchQueue = OperationQueue()
    var operations: [String : Operation] = [:]
    var cache = Cache<String, Data>()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUser { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        let user = userController.users[indexPath.row]
        // more goes here
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let key = user.name
        operations[key]?.cancel()
    }
    
    // MARK: - Functions
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            guard let userDetailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            // final line goes here
        }
    }
    
}
