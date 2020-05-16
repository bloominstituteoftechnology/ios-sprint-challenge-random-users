//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Jarren Campos on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    let userController = UserController()
     var users: [User] = []
     let cache = Cache<String, [UIImage]>()
     private let photoFetchQueue = OperationQueue()
     let queue = OperationQueue.main
     var storedOperations: [String : Operation] = [:]
    
    
    @IBAction func addUsersButton(_ sender: Any) {
        userController.fetchUsers { (users, error) in
              self.users = users ?? []
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
          }
    }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") else { return UITableViewCell()}

        let user = users[indexPath.row]
        
        let name = user.name
        let first = name.first
        let last = name.last
        let title = name.title
        let fullName = "\(title.capitalized) \(first.capitalized) \(last.capitalized)"
        
        cell.textLabel?.text = fullName
        cell.imageView?.image = UIImage(named: "Lambda_Logo_Full")
        loadThumbnail(forCell: cell, forRowAt: indexPath)
        
        return cell
    }

    private func loadThumbnail(forCell cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        if cache.value(forKey: user.email) != nil, let image = cache.value(forKey: user.email)?[0] {
            
            cell.imageView?.image = image
            return
        }
        
        let fetchThumb = FetchThumbnailOperation(user: user, imageURL: user.picture.thumbnail)
        
        let storeDataOperation = BlockOperation {
            guard let data = fetchThumb.imageData else {
                NSLog("fetchThumb.imageData does not have valid data")
                return
            }
            let thumbImage = UIImage(data: data) ?? #imageLiteral(resourceName: "MarsPlaceholder")
            self.cache.cache(value: [thumbImage], forKey: user.email)
        }
        
        let setImageViewOperation = BlockOperation {
            if (self.tableView .cellForRow(at: indexPath) != nil),
                let data = fetchThumb.imageData,
                let image = UIImage(data: data) {
            
                cell.imageView?.image = image
                
                let name = user.name
                let title = name.title
                let first = name.first
                let last = name.last
                let fullName = "\(title.capitalized). \(first.capitalized) \(last.capitalized)"
                cell.textLabel?.text = fullName
                return
            }
        }
        
        storeDataOperation.addDependency(fetchThumb)
        setImageViewOperation.addDependency(fetchThumb)
        
        photoFetchQueue.addOperations([fetchThumb, storeDataOperation], waitUntilFinished: true)
        queue.addOperation(setImageViewOperation)
        storedOperations[user.email] = fetchThumb
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            let usersDetailVC = segue.destination as! DetailViewController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let user = users[index]
            usersDetailVC.user = user
            usersDetailVC.cache = cache
        }
    }

}
