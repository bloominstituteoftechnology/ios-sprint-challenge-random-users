//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by John Pitts on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addUsersButtonPressed(_ sender: Any) {
        
        // Begin fetching users by calling GET method to download from api
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "banged" bc if cell not there whole program worthless anyhow
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        cell.cellNameLabel.text = userController.users[indexPath.row].name

        // Call a func to manage clever downloading/handling of Users PICTURE DATA into cells
        
        // func will need to check cache first, then user proper cancels and order of Operations to manage fast queues/threads

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "UserDetail" {
            guard let destinationVC = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let user = userController.users[indexPath.row]
            destinationVC.usersController = userController
        }
        
        
        // Pass User object to custom cell
    }
    
    // MARK: PROPERTIES
    
    var userController = UserController()

}
