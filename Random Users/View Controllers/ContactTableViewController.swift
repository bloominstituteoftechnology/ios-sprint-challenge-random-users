//
//  ContactTableViewController.swift
//  Random Users
//
//  Created by Bronson Mullens on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    // MARK: - Properties
    var apiController = APIController()
    var contacts: [Contact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    var operation = [String : Operation]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.fetchContacts { (result) in
            do {
                let contacts = try result.get()
                DispatchQueue.main.async {
                    self.contacts = contacts.results
                }
            } catch {
                NSLog("Error fetching contacts")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier, for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        
        let contact = contacts[indexPath.row]
        let fullName:String = ("\(contact.name.title) \(contact.name.first) \(contact.name.last)")
        cell.contactNameLabel.text = "\(fullName)"
        
        if let cachedImage = cache.getValue(key: contact.email) {
            cell.contactImageThumbnail.image = UIImage(data: cachedImage)
            // return
        }
        
        let photoFetchRequest = FetchPhotoOperation(contact: contact)
        
        let storeDataInCache = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            self.cache.sendToCache(value: data, key: contact.email)
        }
        
        let hasBeenReused = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            cell.contactImageThumbnail.image = UIImage(data: data)
        }
        
        storeDataInCache.addDependency(photoFetchRequest)
        hasBeenReused.addDependency(photoFetchRequest)
        
        photoFetchQueue.addOperation(photoFetchRequest)
        photoFetchQueue.addOperation(storeDataInCache)
        
        OperationQueue.main.addOperation(hasBeenReused)
        operation[contact.email] = photoFetchRequest
        
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetailSegue" {
            if let detailVC = segue.destination as? ContactDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.apiController = apiController
                detailVC.contact = contacts[indexPath.row]
            }
        }
    }

}
