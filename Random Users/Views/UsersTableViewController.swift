//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by denis cedeno on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = userController.users[indexPath.row].name
//        cell.imageView?.image = userController.users[indexPath.row].pictureThumbnail
        return cell
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? UsersDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        detailVC.user = userController.users[indexPath.row]
    }


}
