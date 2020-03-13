//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
      private let userController = UserController()
      private let reuseCellID = "UserCell"
    
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        userController.fetchUsers { (users, error) in
                   //
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
               }
    }
    
    
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
//MARK:- Table View Data Source
    
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellID, for: indexPath)
        let currentUser = userController.users[indexPath.row]
        cell.textLabel?.text = currentUser.name
        cell.imageView?.load(url: currentUser.thumbNailImage)
        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellSegueToDetail"  {
            let destVC = segue.destination as! UserDetailViewController
            guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
            let selectedUser = userController.users[selectedIndex.row]
            destVC.user = selectedUser
        }
    }
    
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
