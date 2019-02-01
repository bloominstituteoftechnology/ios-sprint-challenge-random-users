//
//  NewTableViewController.swift
//  Random Users
//
//  Created by Audrey Welch on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class NewTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as? UserTableViewCell else {return UITableViewCell()}
        let user = UserController.shared.users[indexPath.row]
        cell.user = user
        return cell
    }
    

    

}
