//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Lisa Sampson on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        randomUserController.fetchRandomUsers { (randomUsers, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.randomUsers = randomUsers
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUsers?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUserCell", for: indexPath) as! RandomUserTableViewCell

        let randomUser = randomUsers?[indexPath.row]
        cell.nameLabel.text = randomUser?.name

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailView" {
            let detailVC = segue.destination as! RandomUserDetailViewController
        }
    }
    
    let randomUserController = RandomUserController()
    var randomUsers: [RandomUser]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var cache: Cache<String, [String: UIImage]> = Cache()
    
}
