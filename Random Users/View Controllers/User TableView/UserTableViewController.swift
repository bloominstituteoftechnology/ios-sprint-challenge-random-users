//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    //MARK: - Actions

    @objc private func refresh() {
        fetchUsers {
            self.refreshControl?.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

    }

    //MARK: - Private

    private let usersClient = UserClient()
    private var users: [Users] = [] { didSet { tableView.reloadData() }}

    private var thumbnailCache = Cache<URL, Data>(size: 1_000_000)
    private var imageCache = Cache<URL, Data>(size: 1_000_000)

    private func fetchUsers(completion: @escaping () -> Void = {}) {
        usersClient.fetchUsers { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell()}
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
