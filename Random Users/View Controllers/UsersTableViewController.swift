//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Samantha Gatt on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userClient.fetchUsers { (users, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.users = users
        }
    }
    
    // MARK: - Properties
    
    let userClient = UserClient()
    var users: [User]?
    var cache: Cache<String, [String: UIImage]> = Cache()
    
    // MARK: - Actions
    
    @IBAction func loadMoreUsers(_ sender: Any) {
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            
        }
    }
}
