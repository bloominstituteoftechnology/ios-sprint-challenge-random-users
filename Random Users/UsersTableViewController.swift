//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Harmony Radley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    // MARK: - Properties

    private let userController = UserController()
    private let imageCache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    private var fetchOperations: [String : FetchImageOperation] = [:]

    var users: [User]? {
           didSet {
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.fetchRandomUser { users in
            do {
                let users = try users.get()
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                if let error = error as? NetworkError {
                    NSLog("Error in getting users: \(error)")
                    return
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell

        self.loadImage(forCell: cell, forItemAt: indexPath)

        guard let user = users?[indexPath.row] else { return cell }
        cell.nameLabel.text = user.name

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row],
            let email = user.email else { return }

        fetchOperations[email]?.cancel()
    }


   private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {

       guard let user = users?[indexPath.row],
           let email = user.email else { return }

       // Check for an image in cache
    if let cachedImageData = imageCache.value(key: email),
        let image = UIImage(data: cachedImageData) {
        cell.userImageView.image = image
        return
       }

           let fetchOperation = FetchImageOperation(user: user)

           let cacheOperation = BlockOperation {
            if let data = fetchOperation.imageData {
               self.imageCache.cache(key: email, value: data)
           }
    }
           // Download Image/Information
           let imageOperation = BlockOperation {
               defer { self.fetchOperations.removeValue(forKey: email) }

                if let currentIndexPath = self.tableView.indexPath(for: cell),

                       currentIndexPath != indexPath {
                       print("Image for reused cell.")

                       return
                   }

               if let data = fetchOperation.imageData {
                cell.userImageView?.image = UIImage(data: data)
                cell.nameLabel.text = user.name
        }
    }

    photoFetchQueue.addOperation(fetchOperation)
    photoFetchQueue.addOperation(cacheOperation)
    cacheOperation.addDependency(fetchOperation)
    imageOperation.addDependency(fetchOperation)
    OperationQueue.main.addOperation(imageOperation)

    fetchOperations[email] = fetchOperation
   }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            let usersDetailVC = segue.destination as! UserDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            usersDetailVC.user = users?[indexPath.row]
        }
    }
}
