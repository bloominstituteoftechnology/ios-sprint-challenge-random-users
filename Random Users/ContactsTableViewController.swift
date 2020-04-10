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
    
    var cache = Cache<String, Data>()
    
    var operations: [String: Operation] = [:]
    
    let photoFetchQueue = OperationQueue()
    
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
    
    // MARK: - Actions
    
    private func loadImage(forCell cell: ContactTableViewCell, forItemAt indexPath: IndexPath) {
        let contact = contactController.contacts[indexPath.row]
        
        if let data = cache.value(for: contact.name) {
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    cell.contactImage.image = image
                }
            }
        }
        
        let fetchPhotoOperation = FetchPhotoOperation(contact: contact)
        
        let storedImageOperation = BlockOperation {
            if let data = fetchPhotoOperation.imageData {
                self.cache.cache(value: data, for: contact.name)
            }
        }
        
        let completionOperation = BlockOperation {
            if let _ = self.tableView.indexPath(for: cell) {
                if let data = fetchPhotoOperation.imageData {
                    cell.contactImage.image = UIImage(data: data)
                } else {
                    return
                }
            }
        }
        
        storedImageOperation.addDependency(fetchPhotoOperation)
        completionOperation.addDependency(fetchPhotoOperation)
        photoFetchQueue.addOperation(fetchPhotoOperation)
        photoFetchQueue.addOperation(storedImageOperation)
        OperationQueue.main.addOperation(completionOperation)
        
        operations[contact.name] = fetchPhotoOperation
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactController.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let contact = contactController.contacts[indexPath.row]
        operations[contact.name]?.cancel()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        loadImage(forCell: cell, forItemAt: indexPath)
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
