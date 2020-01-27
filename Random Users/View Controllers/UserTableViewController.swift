//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var userController = UserController()
    var cache = Cache<Int, Friend>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.fetchUsers(completion: { (error) in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }

        let friend = userController.results[indexPath.row]
        cell.friend = friend
        cell.userController = userController

        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            guard let userDetailVC = segue.destination as? UserViewController else { return }
            if let indexPath = tableView.indexPathForSelectedRow {
                userDetailVC.friend = userController.results[indexPath.row]
                userDetailVC.userController = userController
            }
        }
    }

}
