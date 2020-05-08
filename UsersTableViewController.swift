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
            let user = userClient.users[indexPath.row]
            cell.textLabel?.text = user.name.first.capitalized + " " + user.name.last.capitalized
            guard let imageData = try? Data(contentsOf: user.picture.thumbnail) else { fatalError() }
            cell.imageView?.image = UIImage(data: imageData)
            return cell
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



