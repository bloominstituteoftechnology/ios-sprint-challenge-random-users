//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jon Bash on 2019-12-06.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var users = [RandomUser]()
    var apiController = APIController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell
            else { return UITableViewCell() }
        
        cell.user = users[indexPath.row]

        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        apiController.fetchUsers(completion: didFetchUsers(with:))
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Private Methods
    
    private func didFetchUsers(with result: Result<[RandomUser], Error>) {
        do {
            users = try result.get()
        } catch {
            print("Error fetching users: \(error)")
        }
    }
}
