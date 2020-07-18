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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let fetchUsersOp = FetchUserOperation()
    
    var user: User?
    var cache = Cache<Int, Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsersOp.fetchUsers { (users, error) in
            guard error == nil, let users = users else {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.users = users
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) 
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name.fullName
        
        let fetchPhotoOperation = FetchPhotoOperation(user: user, imageSize: .thumbnail)
        
        fetchPhotoOperation.fetchImage(from: user.picture.thumbnail) { (data, error) in
            guard error == nil else {
                NSLog("Error fetching image: \(error)")
                return
            }
            guard let imageData = data else { return }
            
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue", let userDetailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            let user = users[indexPath.row]
            userDetailVC.user = user
        }
    }
}
