//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.getUsers { (error) in
            if let error = error {
                NSLog("problem fetching users \(error)")
                return
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let user = userController.users[indexPath.row]
        cell.textLabel?.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
        
        userController.loadUserImageForCell(user: user, cell: cell)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            if let vc = segue.destination as? UserDetailViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    vc.user = userController.users[indexPath.row]
                    vc.userController = userController
                }
            }
        }
    }
    
    let userController = UserController()
}
