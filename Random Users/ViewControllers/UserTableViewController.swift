//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Jerrick Warren on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchUsersOp = FetchUserOp(url: fetchURL)
        guard let users = fetchUsersOp.users else { return}
        self.users = users
        
    }

    // Property observer
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Properties
    
    let reuseIdentifier = "UserCell"
    let fetchURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=200")!
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let destinationVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            destinationVC.user = user
        }
    }
    
    
    // MARK: - Outlets
    @IBAction func addUsers(_ sender: Any) {
        
        
        
    }
    
    

}
