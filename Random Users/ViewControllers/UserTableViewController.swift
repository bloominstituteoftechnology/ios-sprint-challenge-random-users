//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    private let userController = UserController()
    private var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers { (result) in
            guard let users = try? result.get() else { return }
            
            DispatchQueue.main.async {
                self.users = users
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        let user = users[indexPath.row]
        
        cell.textLabel?.text = "\(user.name.title). \(user.name.first) \(user.name.last)"
        
        userController.fetchImage(at: user.picture.thumbnail) { (result) in
            guard let image = try? result.get() else { return }
            
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        }
        return cell
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue", let userDetailVC = segue.destination as? UserDetailViewController, let selectedIndexPath = tableView.indexPathForSelectedRow {
                userDetailVC.userController = userController
            userDetailVC.user = userController.results[selectedIndexPath.row]
        }
    }
}
