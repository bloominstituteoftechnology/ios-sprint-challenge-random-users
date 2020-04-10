//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let randomUserClient = RandomUserClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    // MARK: - Private
    
    private var users: [User] = [] { didSet { tableView.reloadData() }}
    private var thumbnailCache = Cache<URL, Data>(size: 10_000)
    private var imageCache = Cache<URL, Data>(size: 10_000)
    
    private func fetchUsers() {
        randomUserClient.fetchUsers { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {
            fatalError("Could not cast cell as \(UserTableViewCell.self)")
        }
        cell.thumbnailCache = thumbnailCache
        cell.user = users[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userDetailVC = segue.destination as? UserDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            userDetailVC.imageCache = imageCache
            userDetailVC.user = users[indexPath.row]
        }
    }
}
