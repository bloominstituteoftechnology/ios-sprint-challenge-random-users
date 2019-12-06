//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_204 on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let userController = UserController()
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.tableView?.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userController.fetchRandomUsers { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        cell.user = userController.users.results[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailVC = segue.destination as? UserDetailViewController {
            if segue.identifier == "ShowDetailUserSegue" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.user = userController.users.results[indexPath.row]
                }
            }
        }
    }
}
