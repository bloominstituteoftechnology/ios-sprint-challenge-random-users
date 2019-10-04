//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    var userController = UserController()
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        userController.fetchUsers() { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? RandomUserTableViewCell else { return UITableViewCell() }

        let user = userController.users[indexPath.row]
        cell.fullName.text = "\(user.name.first) \(user.name.last)"
//        cell.imageView = userController.users[indexPath.row].picture.thumbnail

        return cell
    }

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
