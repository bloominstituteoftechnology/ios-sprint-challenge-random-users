//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let userClient = UserClient()
    private let userDataCache = Cache<String, Data>() // Name and related photo data.
    private let userFetchQueue = OperationQueue() // OperationQueue for fetch in background.
    private var operations = [String : Operation]()  // holding each Operation in a dictionary.

    override func viewDidLoad() {
        super.viewDidLoad()
        userClient.fetchUsers() { (error) in
            if let error = error {
                NSLog("Error performing data task: \(error)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userClient.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        let userReference = userClient.users[indexPath.row]

        if let cachedData = userDataCache.value(key: userReference.email),
            let image = UIImage(data: cachedData) { cell.imageView?.image = image
            cell.textLabel?.text = userReference.name.first.capitalized + " " + userReference.name.last.capitalized
            return cell

        } else {
            let fetchOperation = FetchUserOperation(photo: userReference.picture)
            let cacheOperation = BlockOperation {
                if let data = fetchOperation.imageData {
                    self.userDataCache.cache(key: userReference.email, value: data)
                }
            }

            let displayImageOperation = BlockOperation {
                defer {self.operations.removeValue(forKey: userReference.email)}
            }
            if let data = fetchOperation.imageData {
                cell.imageView?.image = UIImage(data: data)
                cell.textLabel?.text = userReference.name.first.capitalized + " " + userReference.name.last.capitalized
            }
            userFetchQueue.addOperation(fetchOperation) // fetching operation
            userFetchQueue.addOperation(cacheOperation)
            cacheOperation.addDependency(fetchOperation) // can't cache until we have an image to cache
            displayImageOperation.addDependency(fetchOperation)
            OperationQueue.main.addOperation(displayImageOperation) // moving our finished images to the main queue

            operations[userReference.email] = fetchOperation
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        //TODO set up cancellation.

        let userReference = userClient.users[indexPath.row]
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetail" {
            guard let userDetailVC = segue.destination as? UserDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userClient.users[indexPath.row]
            userDetailVC.user = user
        }
    }
}



