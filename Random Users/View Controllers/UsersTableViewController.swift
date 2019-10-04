//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jake Connerly on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers(amountOfUsers: 1000) { (users, error) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? CustomUserTableViewCell else { return UITableViewCell() }
        let user = userController.users[indexPath.row]
        let userName = "\(user.name.firstName) \(user.name.lastName)"
        let imageURL = user.picture.thumbNailURL
              if let imageData = try? Data(contentsOf: imageURL),
              let image = UIImage(data: imageData) {
                cell.userImageView.image = image
        }
        cell.nameLabel.text = userName
        
        return cell
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserSegue" {
            guard let detailVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            detailVC.user = user
        }
    }
    

}
