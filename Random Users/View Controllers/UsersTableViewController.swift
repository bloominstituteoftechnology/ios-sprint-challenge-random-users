//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Juan M Mariscal on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    private let cache = Cache<Int, UIImage>()
    let userController = UserController()
    var user: User?
    //var userPhoto: User.Picture
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.fetchUsers { (possibleError) in
            guard possibleError == nil else {
                print("Error fetching Users: \(possibleError!)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UsersTableViewCell else {
            fatalError("Can't dequeue cell of type 'UserCell'")
        }
        // Configure the cell...
        let user = userController.userList[indexPath.row]
        
        cell.userNameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        cell.userImageView.image = UIImage(named: user.picture.thumbnail)

        return cell
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let navController = segue.destination as! UsersDetailViewController
            navController.user = userController.userList[indexPath.row]
        }
    }
    


}
