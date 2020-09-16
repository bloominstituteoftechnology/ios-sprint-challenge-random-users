//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by BrysonSaclausa on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    var contactController = ContactController()
    private let cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    var operation = [String : Operation]()
    
    var contacts: [Contact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactController.fetchContacts { (result) in
            do {
                let contacts = try result.get()
                DispatchQueue.main.async {
                    self.contacts = contacts.results
                }
            } catch {
                print("error")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create your cell 
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        
        //After creating the cell, update the properties of the cell with appropriate data values.
        updateCell(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentFetchOperation = contacts[indexPath.row]
        
        guard let currentOperation = operation[currentFetchOperation.email] else { return }
        
        if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
        currentOperation.cancel()
        return
        }
    }
   
    private func updateCell(cell: ContactTableViewCell, forItemAt indexpath: IndexPath) {
        let contact = contacts[indexpath.row]
        cell.contactNameLabel.text = "\(contact.name.title). \(contact.name.first) \(contact.name.last)"
        
        let photoFetchRequest = FetchContactPhotoOperation(contact: contact)
        
        if let cachedImage = cache.getValue(for: contact.picture.thumbnail){
            cell.contactImageView.image = UIImage(data: cachedImage)
            return
        }
        
        
        
        let storeDataInCache = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            self.cache.storeInCache(value: data, for: contact.email)
        }
        
        let wasReused = BlockOperation {
//            defer { self.operation.removeValue(forKey: photoFetchRequest.contact.email)}
//            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexpath {
//                print("no path")
//            }
            guard let data = photoFetchRequest.imageData else { return }
            cell.contactImageView.image = UIImage(data: data)
        }
        
        storeDataInCache.addDependency(photoFetchRequest)
        wasReused.addDependency(photoFetchRequest)
        //adding photoFetchRequest to operationQueue
        photoFetchQueue.addOperation(photoFetchRequest)
        
        photoFetchQueue.addOperation(storeDataInCache)
        OperationQueue.main.addOperation(wasReused)
        operation[contact.email] = photoFetchRequest
    }

  

    



    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetailSegue"{
            if let detailVC = segue.destination as? ContactDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow{
                detailVC.contactController = contactController
                detailVC.contact = contacts[indexPath.row]
            }
        }
    }

}
