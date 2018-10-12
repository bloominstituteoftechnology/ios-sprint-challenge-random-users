//
//  ContactTableViewController.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    let contactController = ContactController()
    private let fetchImageQueue = OperationQueue()
    private let cache = Cache<String, Data>()

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
    
    private func loadImage(for cell: UITableViewCell, at indexPath: IndexPath) {
        let contact = contactController.contacts[indexPath.row]
        
        if let imageData = cache.value(for: contact.id),
            tableView.cellForRow(at: indexPath) === cell {
            cell.imageView?.image = UIImage(data: imageData)
            return
        }
        
        let thumbnailFetchOperation = FetchImageOperation(contact: contact)
        let cacheImageOperation = BlockOperation { [weak self] in
            if let imageData = thumbnailFetchOperation.imageData {
                self?.cache.cache(value: imageData, for: contact.id)
            }
        }
        let updateUIOperation = BlockOperation { [weak self] in
            if let imageData = thumbnailFetchOperation.imageData,
                self?.tableView.cellForRow(at: indexPath) === cell {
                cell.imageView?.image = UIImage(data: imageData)
                cell.setNeedsLayout()
            }
        }
        
        cacheImageOperation.addDependency(thumbnailFetchOperation)
        updateUIOperation.addDependency(thumbnailFetchOperation)
        
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
            
            destinationVC.contact = contact
            if let thumbnailData = thumbnailData {
                destinationVC.tempImage = UIImage(data: thumbnailData)
            }
        }
    }

}
