//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Bobby Keffury on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var userController = UserController()
    var user: User?
    var users: [User] = []
    private let cache = Cache<Int, Data>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }

        let user = self.users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    
    
    @IBAction func searchUsersTapped(_ sender: Any) {
        userController.searchForUsers { (result) in
            DispatchQueue.main.async {
                do {
                    let result = try result.get()
                    self.users = result.results
                    self.tableView.reloadData()
                } catch {
                    print("Error getting result: \(error)")
                }
            }
        }
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
          
       }
    

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailShowSegue" {
            if let detailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                detailVC.user = users[indexPath.row]
            }
        }
    }
    

}
