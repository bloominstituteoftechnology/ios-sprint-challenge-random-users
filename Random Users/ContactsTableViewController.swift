//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 10/04/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let contactController = ContactController()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactController.fetchContacts { error in
            if let error = error {
                NSLog("Error fetching contacts to table view: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactController.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }

        let contact = contactController.contacts[indexPath.row]
        cell.contact = contact

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowContactDetailSegue" {
            if let contactDetailVC = segue.destination as? ContactDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                let contact = contactController.contacts[indexPath.row]
                contactDetailVC.contact = contact
            }
        }
    }
}
