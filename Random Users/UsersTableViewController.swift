//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jason Modisett on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        userController.getUsersFromAPI { _ in
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }

    // MARK:- Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let user = userController.users[indexPath.row]
        
        cell.textLabel?.text = user.name.formatted.3
        
        return cell
    }

    /*
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    */
    
    // MARK:- Properties & types
    let userController = UserController()

}
