//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Madison Waters on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.fetchUsers { (_),_  in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        let user = userController.users[indexPath.row]
        loadImage(forCell: cell, forItemAt: indexPath)
        cell.textLabel?.text = user.firstName

        return cell
    }
    
    // Used for Cancel capability // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation // UserToDetail

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserToDetail" {
            guard let detailVC = segue.destination as? DetailViewController else { return }
            detailVC.userController = userController
        }
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let thumbPic = UIImage()

        DispatchQueue.main.async {
            cell.imageView?.image = thumbPic
            //cell.imageView?.image = cell.imageView.thumbPic
        }
        
    }
    
    // Mark: Properties
    let user = [User]()
    
    let userController = UserController()
}
