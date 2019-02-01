//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    
    
    let randomUserController = RandomUserController()
    var randomUsersModel: [RandomUsersModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        randomUserController.getRandomUsers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)

        
        let userImageURL = randomUserController.users[indexPath.row].results[indexPath.row].picture.thumbnail
        let userFirstName = randomUserController.users[indexPath.row].results[indexPath.row].name.first
         let userLastName = randomUserController.users[indexPath.row].results[indexPath.row].name.last
        cell.imageView?.image = UIImage(named: userImageURL)
        cell.textLabel?.text = "\(userFirstName) \(userLastName)"

        print("\(userFirstName) \(userLastName)")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailDVC = segue.destination as! RandomUserDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            detailDVC.randomUser = randomUsersModel?[index.row].results[index.row]
        }
    }
}
