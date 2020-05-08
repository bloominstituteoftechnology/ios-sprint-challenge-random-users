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

    let cache = Cache<String, Data>()
    private let queue = OperationQueue()
    private var operations = [String : Operation]()

    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userClient.fetchUsers { (users, error) in
            if let error = error {
                print("Error performing data task: \(error)")
                return
            }
            self.users = users
            }
        }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        guard let user = users?[indexPath.row] else { return cell }
        cell.nameLabel.text = user.name

        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row],
            let email = user.email else { return }

        operations[email]?.cancel()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetail" {
            guard let userDetailVC = segue.destination as? UserDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            userDetailVC.user = users?[indexPath.row]
        }
    }

    // MARK: - Methods

    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {

        guard let user = users?[indexPath.row],
        let email = user.email else { return }

        if let image = cache.value(key: email) {
            cell.userImageView?.image = UIImage(data: image)

        } else {
            let fetchOperation = FetchImageOperation(userRandom: user)
            let cacheOperation = BlockOperation {
                guard let data = fetchOperation.imageData else { return }
                    self.cache.cache(key: email, value: data)
            }

            let displayImageOperation = BlockOperation {
                defer {self.operations.removeValue(forKey: email)}
            }
            if let data = fetchOperation.imageData {
                cell.imageView?.image = UIImage(data: data)
                cell.nameLabel?.text = user.name
            }
            queue.addOperation(fetchOperation)
            queue.addOperation(cacheOperation)
            cacheOperation.addDependency(fetchOperation)
            displayImageOperation.addDependency(fetchOperation)
            OperationQueue.main.addOperation(displayImageOperation)

            operations[email] = fetchOperation
        }
    }
}


