//
//  ContactManagerTableViewController.swift
//  Random Users
//
//  Created by Clayton Watkins on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactManagerTableViewController: UITableViewController {

    // MARK: - Properties
    var apiController = APIController()
    var contacts: [Contact] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private let cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    var operation = [String : Operation]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.getContacts { (result) in
            do{
                let contacts = try result.get()
                DispatchQueue.main.async {
                    self.contacts = contacts.results
                }
            }catch{
                print("Error getting contacts")
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        updateCell(forCell: cell, forItemAt: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Private Functions
    private func updateCell(forCell cell: ContactTableViewCell, forItemAt indexpath: IndexPath){
        // Getting the contact
        let contact = contacts[indexpath.row]
        // Setting the contact's name label to the correct name
        cell.contactNameLabel.text = "\(contact.name.title) \(contact.name.first) \(contact.name.last)"
        
        if let cachedImage = cache.getValue(for: contact.email){
            cell.contactImageView.image = UIImage(data: cachedImage)
            return
        }
        
        let photoFetchRequest = FetchContactPhotoOperation(contact: contact)
        
        let storeDataInCache = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            self.cache.storeInCache(value: data, for: contact.email)
        }
        
        let beenReused = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            cell.contactImageView.image = UIImage(data: data)
        }
        
        storeDataInCache.addDependency(photoFetchRequest)
        beenReused.addDependency(photoFetchRequest)
        
        photoFetchQueue.addOperation(photoFetchRequest)
        photoFetchQueue.addOperation(storeDataInCache)
        OperationQueue.main.addOperation(beenReused)
        
        operation[contact.email] = photoFetchRequest
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

}
