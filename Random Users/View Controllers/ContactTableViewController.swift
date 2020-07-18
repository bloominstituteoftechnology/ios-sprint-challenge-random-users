//
//  ContactTableViewController.swift
//  Random Users
//
//  Created by Morgan Smith on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    let contactController = ContactController()
    var fetchPhotoOperations: [Int: FetchPhotoOperation] = [:]
    private let photoFetchQueue = OperationQueue()
    var thumbnailCache = Cache<Int, Data>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        photoFetchQueue.name = "photoFetchQueue"
        contactController.fetchContacts { (error) in
            if let error = error {
                print("error fetching contacts: \(error)")
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        guard let contactCell = cell as? ContactTableViewCell else { return cell }
        let contact = contactController.contacts[indexPath.row]
        contactCell.contactName?.text = contact.name
        loadImage(forCell: contactCell, forItemAt: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if contactController.contacts.count > 0 {
            fetchPhotoOperations[indexPath.row]?.cancel()
        } else {
            for (_, operation) in fetchPhotoOperations {
                operation.cancel()
            }
        }
    }


    private func loadImage(forCell cell: ContactTableViewCell, forItemAt indexPath: IndexPath) {
        if let imageData = thumbnailCache.value(for: indexPath.row) {
            cell.contactImage?.image = UIImage(data: imageData)
        }

        let contact = contactController.contacts[indexPath.row]
        let fetchPhotoOperation = FetchPhotoOperation(contactImageUrl: contact.picture[0])

        let storeToCache = BlockOperation {
            if let imageData = fetchPhotoOperation.imageData {
                self.thumbnailCache.cache(value: imageData, for: indexPath.row)
            }
        }

        let cellReuseCheck = BlockOperation {
            if self.tableView.indexPath(for: cell) == indexPath {
                guard let imageData = fetchPhotoOperation.imageData else { return }
                cell.contactImage.image = UIImage(data: imageData)
            }
        }

        storeToCache.addDependency(fetchPhotoOperation)
        cellReuseCheck.addDependency(fetchPhotoOperation)

        photoFetchQueue.addOperations([fetchPhotoOperation, storeToCache], waitUntilFinished: false)
        OperationQueue.main.addOperation(cellReuseCheck)
        fetchPhotoOperations[indexPath.row] = fetchPhotoOperation
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetail" {
                guard let detailVC = segue.destination as? ContactDetailViewController,
                    let indexpath = tableView.indexPathForSelectedRow    else { return }

                let contactIndex = indexpath.row
                let contact = contactController.contacts[contactIndex]
                detailVC.contact = contact
                detailVC.contactController = contactController
                detailVC.contactIndex = contactIndex
            }

    }


}
