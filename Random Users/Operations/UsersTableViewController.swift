//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    

    
   let randomUsersApiController = RandomUsersApiController()
    private let photoFetchQueue = OperationQueue()
    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.randomUsersApiController.fetchRandomUserDetails {_ in
            DispatchQueue.main.async { self.tableView.reloadData()
                
            }
        }

    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUsersApiController.users.count
    }

    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        let user = randomUsersApiController.users[indexPath.row]

        // Check if there is cached data
        if let cachedData = cache.value(key: user.email),
            let image = UIImage(data: cachedData) {
            cell.imageView?.image = image
            return
        }

        // Start our fetch operations
        let fetchOp = FetchPhotoOperation(user: user) // change to the
        
        // saving
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(key: user.email, value: data)
            }
        }

        // populating the image
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: user.email) } //switch id to email or phone numbers same as funcs above
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                // refering to the for item at indexpath that is passed in above, not in the line of code below
                currentIndexPath != indexPath {
                print("Got image for reused cell")
                return
            }

            if let data = fetchOp.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }

        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)

        OperationQueue.main.addOperation(completionOp)

        operations[user.email] = fetchOp

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UsersTableViewCell else { return UsersTableViewCell() }

        let user = randomUsersApiController.users[indexPath.row]
        cell.user = user
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let thumbnailReference = randomUsersApiController.users[indexPath.row]
        operations[thumbnailReference.thumbnailImage.absoluteString]?.cancel()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailShowSegue" {
            guard let detailVC = segue.destination as? UsersDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.user = randomUsersApiController.users[indexPath.row]
        }
    }
}
