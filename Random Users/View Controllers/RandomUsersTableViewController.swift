//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RandomUserController.shared.randomUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUser", for: indexPath) as! RandomUserTableViewCell
        cell.randomUser = RandomUserController.shared.randomUsers[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRandomUser" {
            let randomUserViewController = segue.destination as! RandomUserViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let randomUser = RandomUserController.shared.randomUsers[indexPath.row]
                randomUserViewController.randomUser = randomUser
            }
        }
    }
}
