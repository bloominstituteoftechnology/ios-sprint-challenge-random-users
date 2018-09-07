//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController
{
    var userController = UserController()
    var users: [User]?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userController.getUsers { (users, error) in
            if let error = error
            {
                NSLog("error fetching users: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.users = users
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)

        let user = userController.users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.imageView?.image = user.thumbnail
        

        return cell
    }
    
    private func loadUser(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath)
    {
        
    }
    
    // MARK: - Navigation
     //ShowDetail
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
///////end
}
