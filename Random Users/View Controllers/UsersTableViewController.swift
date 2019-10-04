//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jake Connerly on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    //MARK: - Properties
    
    let userController = UserController()
    private let photoFetchQueue = OperationQueue()
    let cache = Cache<String, Data>()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers(amountOfUsers: 1000) { (users, error) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - IBActions & Methods
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    private func loadImage(forCell: CustomUserTableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        
        
        if let cachedData = 
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
}
