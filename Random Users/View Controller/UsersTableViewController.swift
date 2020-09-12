//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Norlan Tibanear on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    var userController = UserController()
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let cache = Cache<String, Data>()
    private let photoQueue = OperationQueue()
    var operation = [String: Operation]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        
        
        return cell
        
    }
    
    
    func updateCell(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        cell.usernameLabel.text = "\(user.name.title)"
        
        
        
    }
    
    
    

   

} // Class
