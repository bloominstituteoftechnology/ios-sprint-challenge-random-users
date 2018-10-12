//
//  ContactTableViewController.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    // MARK: - Properties
    let contactController = ContactController()
    private let fetchImageQueue = OperationQueue()
    private let cache = Cache<String, Data>()
    private var fetchOperations: [String: FetchImageOperation] = [:]

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        contactController.fetchContacts { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        fetchImageQueue.name = "com.dillonMcelhinney.randomUsers.fetchImageQueue"
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactController.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contactController.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        loadImage(for: cell, at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let contact = contactController.contacts[indexPath.row]
        
        if let fetchImageOperation = fetchOperations[contact.id] {
            fetchImageOperation.cancel()
            fetchOperations.removeValue(forKey: contact.id)
        }
    }
    
    // MARK: - Utility Methods
    private func loadImage(for cell: UITableViewCell, at indexPath: IndexPath) {
        // Get the contact for the indexPath
        let contact = contactController.contacts[indexPath.row]
        
        // If there is already cached imageData for that contact, update the cell with that and return
        if let imageData = cache.value(for: contact.id),
            tableView.cellForRow(at: indexPath) === cell {
            cell.imageView?.image = UIImage(data: imageData)
            return
        }
        
        // Otherwise, make an operation to fetch the thumbnail
        let thumbnailFetchOperation = FetchImageOperation(contact: contact)
        // And an operation to cache the data
        let cacheImageOperation = BlockOperation { [weak self] in
            if let imageData = thumbnailFetchOperation.imageData {
                self?.cache.cache(value: imageData, for: contact.id)
            }
        }
        // And an operation to update the UI when it is returned
        let updateUIOperation = BlockOperation { [weak self] in
            if let imageData = thumbnailFetchOperation.imageData,
                self?.tableView.cellForRow(at: indexPath) === cell {
                cell.imageView?.image = UIImage(data: imageData)
                cell.setNeedsLayout()
            }
        }
        
        // Make the cache and UI operations dependent on fetching the thumbnail
        cacheImageOperation.addDependency(thumbnailFetchOperation)
        updateUIOperation.addDependency(thumbnailFetchOperation)
        
        // Add the operation to the private dictionary, so we can cancel it later if necessary
        fetchOperations[contact.id] = thumbnailFetchOperation
        
        // Add the operations to their respective queues
        fetchImageQueue.addOperation(thumbnailFetchOperation)
        fetchImageQueue.addOperation(cacheImageOperation)
        OperationQueue.main.addOperation(updateUIOperation)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowContactSegue" {
            guard let destinationVC = segue.destination as? ContactDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = contactController.contacts[indexPath.row]
            let thumbnailData = cache.value(for: contact.id)
            
            // Set the contact for the detail view controller
            destinationVC.contact = contact
            // If there is cached thumbnail data (which there should be), pass it for the detail view controller to display while the full size image is loading.
            if let thumbnailData = thumbnailData {
                destinationVC.tempImage = UIImage(data: thumbnailData)
            }
        }
    }

}
