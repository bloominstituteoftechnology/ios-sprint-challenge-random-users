//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: - Properties and IBOutlets -
    
    var userController = UserController()
    
    //MARK: - Methods and IBActions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.getUser { (result) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        let currentCellUser = userController.users[indexPath.row]
        let imageURL = currentCellUser.picture.thumbnail
        cell.randomUser = currentCellUser
        
        userController.getUserImage(imageURLString: imageURL) { (result) in
            
            DispatchQueue.main.async {
                do {
                    cell.imageView?.image = try result.get()
                } catch {
                    NSLog("Could not acquire the user's thumbnail image: \(error)")
                    return
                }
            }
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UserDetailSegue" {
            
            guard let detailVC = segue.destination as? UserDetailViewController else { return }
            let selectedUser = userController.users[tableView.indexPathForSelectedRow!.row]
            detailVC.user = selectedUser
            userController.getUserImage(imageURLString: selectedUser.picture.large) { (result) in
                
                DispatchQueue.main.async {
                    
                    do {
                        detailVC.imageView.image = try result.get()
                    } catch {
                        NSLog("Could not acquire meduim size image for the detail view: \(error)")
                        return
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
} //End of class
