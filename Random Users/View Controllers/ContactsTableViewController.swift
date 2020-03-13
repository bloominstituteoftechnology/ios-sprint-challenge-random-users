//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by scott harris on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    let apiController = ApiController()
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        apiController.fetchContacts { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let contacts):
                    self.contacts = contacts
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.firstName
        cell.detailTextLabel?.text = contact.lastName
        
        return cell
    }
    
}
