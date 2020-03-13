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
    let photoFetchQueue = OperationQueue()
    let cache = Cache<String, Data>()
    var imageLoadOperations: [String: FetchPhotoOperation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.fetchContacts { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let contacts):
                    DispatchQueue.main.async {
                        self.contacts = contacts
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
        
        cell.textLabel?.text = "\(contact.title) \(contact.firstName) \(contact.lastName)"
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        
        return cell
    }
    
    func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        
        if let data = self.cache.value(for: contact.thumbnailURL.absoluteString) {
            cell.imageView?.image = UIImage(data: data)
            return
        }
        
        let fetchOp = FetchPhotoOperation(contact: contact)
        let updateCacheOperation = BlockOperation {
            if let data = fetchOp.thumbnailData {
                self.cache.cache(value: data, for: contact.thumbnailURL.absoluteString)
            }
            
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, for: contact.imageURL.absoluteString)
            }
        }
        let cellReuseOperation = BlockOperation {
            defer { self.imageLoadOperations.removeValue(forKey: contact.thumbnailURL.absoluteString) }
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                print("Got image for now-reused cell")
                return // Cell has been reused
                
                
            }
            
            if let data = self.cache.value(for: contact.thumbnailURL.absoluteString) {
                cell.imageView?.image = UIImage(data: data)
                
            }
        }
        updateCacheOperation.addDependency(fetchOp)
        cellReuseOperation.addDependency(updateCacheOperation)
        photoFetchQueue.addOperations([fetchOp, updateCacheOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(cellReuseOperation)
        
        imageLoadOperations[contact.thumbnailURL.absoluteString] = fetchOp
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        let fetchOp = imageLoadOperations[contact.thumbnailURL.absoluteString]
        fetchOp?.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowContactDetailSegue" {
            if let detailVC = segue.destination as? ContactDetailViewController {
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    let contact = contacts[selectedIndex.row]
                    let cachedImageData = cache.value(for: contact.imageURL.absoluteString)
                    detailVC.contact = contact
                    detailVC.imageData = cachedImageData
                }
            }
        }
    }
    
}
