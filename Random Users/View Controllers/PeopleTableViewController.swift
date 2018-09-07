//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Linh Bouniol on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    var userController = UserController()

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.getUsers { (error) in
            if let error = error {
                NSLog("Error getting user data from server: \(error)")
                return
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        let user = userController.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.imageView?.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        
        // use the loadImage func to get images

        return cell
    }
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? PeopleDetailViewController {
            detailVC.userController = userController
            
            if segue.identifier == "ShowDetail" {
                guard let index = tableView.indexPathForSelectedRow?.row else { return }
                let user = userController.users[index]
                detailVC.user = user
            }
        }
    }
}
