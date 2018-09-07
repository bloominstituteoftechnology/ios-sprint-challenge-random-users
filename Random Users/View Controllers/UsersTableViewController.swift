//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userController.getUsers { (error) in
            if let error = error {
                NSLog("problem fetching users \(error)")
                return
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let user = userController.users[indexPath.row]
        cell.textLabel?.text = "\(user.name.first) \(user.name.last)"
        
        loadUserImage(user: user, cell: cell)
        
        return cell
    }
    
    func loadUserImage(user: User, cell: UITableViewCell) {
        let url = URL(string: user.picture.thumbnail)!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting randomUser photo: \(error) - \(url)")
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data)
            }
        }.resume()
    }
    
    let userController = UserController()
}
