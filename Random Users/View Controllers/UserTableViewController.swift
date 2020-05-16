//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Jarren Campos on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") else { return UITableViewCell()}

        let user = users[indexPath.row]
        
        let name = user.name
        let first = name.first
        let last = name.last
        let fullName = "\(first.capitalized) \(last.capitalized)"
        
        cell.textLabel?.text = fullName
        cell.imageView?.image = UIImage(named: "Lambda_Logo_Full")
        
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            let usersDetailVC = segue.destination as! DetailViewController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let user = users[index]
            usersDetailVC.user = user
        }
    }

}
