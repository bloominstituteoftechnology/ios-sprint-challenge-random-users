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
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let destinationVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = randomUserController.users[indexPath.row]
            destinationVC.user = user
        }
    }

    private let cache = Cache<String, Data>()
    private let operations = ConcurrentOperation()
    var randomUserController = RandomUserController()
}
