//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    var userClient = UserClient()
    private let cache = Cache<String, Data>()
    private let imageQueue = OperationQueue()

    private var userInfo: [Users] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userClient.fetchUsers { (error) in
//            if let error = error {
//                NSLog("Error getting data for users: \(error)")
//            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }

    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        print("Cell 1")
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Cell 2")
        return userClient.allUsers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as? UsersTableViewCell else { return UITableViewCell()}

        print("Cell 3")
        let users = userClient.allUsers[indexPath.row]
        cell.textLabel?.text = users.name.title + users.name.first + users.name.last
        let imageKey = users.picture.thumbnail

        cell.result = users
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UsersDetailSegue" {
            guard let detialVC = segue.destination as? DetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userClient.allUsers[indexPath.row]
            detialVC.userResults = user
        }
    }

}

