//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Chris Dobek on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var userController = UserController()
    var cache = Cache<String, Data>()
    private var photoFetchQueue = OperationQueue()
    var operation = [String: Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUserFromServer() { error in
            if let error = error {
                NSLog("Error fetching \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell ?? UserTableViewCell()

        loadImages(for: cell, forItemAt: indexPath)


        return cell
    }
    
    private func loadImages(for cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = userController.users[indexPath.item]
        if let cacheData = cache.value(for: user.name) {
            cell.userImage.image = UIImage(data: cacheData)
            cell.userName.text = user.name
        }
        let fetchOperation = FetchUsersOperation(user: user)
        let cacheOperation = BlockOperation {
            guard let data = fetchOperation.imageData else { return }
            self.cache.cache(value: data, for: user.name)
        }
        cacheOperation.addDependency(fetchOperation)
        photoFetchQueue.addOperation(cacheOperation)
        
        let checkReuse = BlockOperation {
            let currentIndex = self.tableView.indexPath(for: cell)
            guard currentIndex == indexPath, let data = fetchOperation.imageData else { return }
            cell.userImage.image = UIImage(data: data)
            cell.userName.text = user.name
        }
        checkReuse.addDependency(fetchOperation)
        OperationQueue.main.addOperation(checkReuse)
        
        photoFetchQueue.addOperation(fetchOperation)
        operation[user.name] = fetchOperation
    }
        
 

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let detailVC = segue.destination as? DetailViewController,
                let indexpath = tableView.indexPathForSelectedRow else {return}
            detailVC.user = userController.users[indexpath.row]
        }
    }
    
}
