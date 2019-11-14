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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
