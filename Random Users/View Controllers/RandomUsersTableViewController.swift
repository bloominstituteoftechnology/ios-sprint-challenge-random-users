//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    var userController = UserController()
    private let cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [String : Operation]()
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        userController.fetchUsers() { _ in
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
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? RandomUserTableViewCell else { return UITableViewCell() }

        let user = userController.users[indexPath.row]
        cell.fullName.text = "\(user.name.first) \(user.name.last)"
        //cell.thumbnail.image = user.picture.thumbnail

        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromCellSegue" {
            guard let detailVC = segue.destination as? RandomUserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            detailVC.user = user
            detailVC.userController = userController
        }
    }
}
