//
//  ContactsTableViewController.swift
//  ContactManager
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    // MARK:- Properties
    
    let users = UsersController().getUsers()
    
    // MARL:- Table View Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func generateUsers(_ sender: Any) {
        tableView.isHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let users = users?.users else {fatalError()}
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? ContactTableViewCell else {fatalError()}

        
//        guard let users = users?.users else {fatalError()}
//        let user = users[indexPath.row]
//
//        cell.textLabel?.text = user.name

        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
