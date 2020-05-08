//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    // MARK: - Properties

    let userClient = UserClient()

    let cache = Cache<String, Data>() // Name and related photo data.
    private let queue = OperationQueue() // OperationQueue for fetch in background.
    private var operations = [String : Operation]()  // holding each Operation in a dictionary.

    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userClient.fetchUsers() { (error) in
            if let error = error {
                print("Error performing data task: \(error)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = users?[indexPath.row]
        cell.nameLabel.text = user?.name.last

        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row] else { return }

        operations[user.email]?.cancel()
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

    // MARK: - Methods

    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {

        guard let user = users?[indexPath.row] else { return }
        let email = user.email

        if let image = cache.value(key: email) {
            cell.imageView?.image = UIImage(data: image)

        } else {
            let fetchOperation = FetchImageOperation(userRandom: user)
            let cacheOperation = BlockOperation {
                if let data = fetchOperation.imageData {
                    self.cache.cache(key: user.email, value: data)
                }
            }

            let displayImageOperation = BlockOperation {
                defer {self.operations.removeValue(forKey: user.email)}
            }
            if let data = fetchOperation.imageData {
                cell.imageView?.image = UIImage(data: data)
                cell.nameLabel?.text = user.name.first.capitalized + " " + user.name.last.capitalized
            }
            queue.addOperation(fetchOperation) // fetching operation
            queue.addOperation(cacheOperation)
            cacheOperation.addDependency(fetchOperation) // can't cache until we have an image to cache
            displayImageOperation.addDependency(fetchOperation)
            OperationQueue.main.addOperation(displayImageOperation) // moving our finished images to the main queue

            operations[user.email] = fetchOperation
        }
    }
}


