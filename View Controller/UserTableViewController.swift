//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    // MARK: - Properties
    var randomUsersController = RandomUsersController()
    var users: [UserResults] = [] {
        didSet {
            tableView.reloadData()
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
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell()}

        let user = users[indexPath.row]
        cell.user = user

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
            let userDetailVC = segue.destination as? UserDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
                userDetailVC.randomUser = users[selectedIndexPath.row]
            }
    }
    
    // MARK: - IBAction
    
    @IBAction func addUsersButtonPressed(_ sender: Any) {
        randomUsersController.getUsers { (results) in
            do {
                let users = try results.get()
                DispatchQueue.main.async {
                    self.users = users.results
                }
            } catch {
                print(results)
                
            }
        }
        
    }
    
}
