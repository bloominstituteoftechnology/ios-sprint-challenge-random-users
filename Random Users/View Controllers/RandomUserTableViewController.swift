//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Thomas Cacciatore on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? RandomUserTableViewCell else { fatalError("Unable to dequeue cell") }

        let user = randomUserController.users[indexPath.row]
        cell.user = user
//
        return cell
    }
 


    var randomUserController = RandomUserController()
}
