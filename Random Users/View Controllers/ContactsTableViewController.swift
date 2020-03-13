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
        
        cell.textLabel?.text = contact.firstName
        cell.detailTextLabel?.text = contact.lastName
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        
        return cell
    }
    
    func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        let fetchOp = FetchPhotoOperation(contact: contact)
        let cellReuseOperation = BlockOperation {
            //            defer { self.imageLoadOperations.removeValue(forKey: photoReference.id) }
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                print("Got image for now-reused cell")
                return // Cell has been reused
                
                
            }
            
            if let data = fetchOp.thumbnailData {
                cell.imageView?.image = UIImage(data: data)
                
            }
        }
        
        cellReuseOperation.addDependency(fetchOp)
        photoFetchQueue.addOperations([fetchOp], waitUntilFinished: true)
        OperationQueue.main.addOperation(cellReuseOperation)
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
