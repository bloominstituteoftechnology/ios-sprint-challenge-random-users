//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        usersController.fetchUsers(resultsNumber: "1000") { (_) in
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addUsers(_ sender: Any) {
        
        // fetch users code here.
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersController.users.count
    }
    
    let reuseIdentifier = "UserCell"

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let user = usersController.users[indexPath.row]
        
        cell.textLabel?.text = user.name
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // cancel operations
        
    }
    
    // MARK: - Private
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = usersController.users[indexPath.row]
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            
        }
    }
    
    // MARK: - Properties

    let usersController = ModelClient()
    
}
