//
//  FetchUsersTableViewController.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class FetchUsersTableViewController: UITableViewController {
    //=======================
    // MARK: - Types
    enum identifiers: String {
        case userDetail = "UserDetailViewControllerSegue"
    }
    
    //=======================
    // MARK: - Properties
    let users: [User]
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //=======================
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
    
    //=======================
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
