//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_259 on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    let userController = UserController()
    var users: [User] = []
    let cache = Cache<String, [UIImage]>() // [email : [thumb, large]]
    private let photoFetchQueue = OperationQueue()
    let queue = OperationQueue.main
    var storedOperations: [String : Operation] = [:]
    
    // MARK: - IBActions
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let user = users[indexPath.row]
        
        
        cell.user = user
        loadThumbnail(forCell: cell, forRowAt: indexPath)

        return cell
    }
    
    // MARK: - Private
    private func loadThumbnail(forCell cell: UserTableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        //let thumbReference = URL(string: user.picture.thumbnail)
        
        if cache.value(forKey: user.email) != nil, let image = cache.value(forKey: user.email)?[0] {
            
            cell.userThumbImageView.image = image
            return
        }
        
        let fetchThumb = FetchThumbOperation(user: user, imageURL: user.picture.thumbnail)
        
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
                cell.userNameLabel.text = fullName
                return
            }
        }
        
        storeDataOperation.addDependency(fetchThumb)
        setImageViewOperation.addDependency(fetchThumb)
        
        photoFetchQueue.addOperations([fetchThumb, storeDataOperation], waitUntilFinished: true)
        
        queue.addOperation(setImageViewOperation)
        
        storedOperations[user.email] = fetchThumb
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            let usersDetailVC = segue.destination as! UsersDetailViewController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let user = users[index]
            usersDetailVC.user = user
            usersDetailVC.cache = cache
        }
    }

}
