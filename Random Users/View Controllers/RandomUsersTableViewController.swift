//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {

    var user: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var userController = UserController()
    let cache = Cache<User, UIImage>()
    private let queue = OperationQueue()
    private var operations = [User : Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch random user // or init
        // download user data
        userController.fetchRandomUser() 
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell ?? UserTableViewCell()
        
        cell.user = user![indexPath.row]
            
        
        return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let user = user?[indexPath.row] else { return }
        
        if let cachedImageData = cache.value(for: user) {
        
            cell.userImage.image = cachedImageData
        }
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "UserDetailSegue" {
              let usersDetailVC = segue.destination as! DetailViewController
              guard let indexPath = tableView.indexPathForSelectedRow?.row else { return }
            usersDetailVC.user = user![indexPath]
        }
    }
    

}
