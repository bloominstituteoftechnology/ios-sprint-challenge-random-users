//
//  ContactTableViewController.swift
//  Random Users
//
//  Created by Michael on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    let contactController = ContactController()
    
    var operations: [String : Operation] = [:]
    
    let photoFetchQueue = OperationQueue()
    
    var cache = Cache<String, Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactController.fetchContacts { _ in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        let contact = contactController.contacts[indexPath.row]
        cell.contact = contact
        loadImages(forCell: cell, forItemAt: indexPath)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let contact = contactController.contacts[indexPath.row]
        let key = contact.name
        operations[key]?.cancel()
    }
    
    func loadImages(forCell cell: ContactTableViewCell, forItemAt indexPath: IndexPath) {
        let selectedContact = contactController.contacts[indexPath.row]
        let key = selectedContact.name
        
        if let cachedData = cache.thumbnailValue(for: key) {
            let image = UIImage(data: cachedData)
            cell.contactImageView.image = image
            return
        }
            let fetchImage = FetchPhotoOperation(contact: selectedContact)
            
            let storeCacheData = BlockOperation {
                if let data = fetchImage.imageData {
                    self.cache.thumbnailCache(value: data, for: key)
                }
            }
            
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: key) }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                NSLog("Got image for now-reused cell")
                return
            }
            
            if let data = fetchImage.imageData {
                cell.contactImageView.image = UIImage(data: data)
//                cell.contactNameLabel.text = selectedContact.name
            }
        }
            
        
            storeCacheData.addDependency(fetchImage)
            completionOp.addDependency(fetchImage)
            photoFetchQueue.addOperations([fetchImage, storeCacheData], waitUntilFinished: false)
            OperationQueue.main.addOperation(completionOp)
            
            operations[key] = fetchImage
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetailSegue" {
            guard let contactDetailVC = segue.destination as? ContactDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = contactController.contacts[indexPath.row]
            contactDetailVC.contact = contact
        }
    }
}
