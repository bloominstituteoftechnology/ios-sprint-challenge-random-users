//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by John McCants on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    
    var contacts : [Contact] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var networkingController = NetworkingController()

    private let cache = Cache<String,Data>()
    private let photoFetchQueue = OperationQueue()
    var operations = [String : Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkingController.getContacts { (result) in
            do {
                let contacts = try result.get()
                DispatchQueue.main.async {
                    self.contacts = contacts.results
                }
            } catch {
                print("Error fetching contacts")
            }
        }
        }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contacts.count
    }
    
    private func loadStuffInCell(cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        // TODO: Implement image loading here
                let contact = contacts[indexPath.row]
                let fullName = "\(contact.name.first) \(contact.name.last)"
                cell.userName.text = fullName
        
        
        if let data = cache.getValue(key: contact.email) {
            if self.tableView.indexPath(for: cell) == indexPath {
                cell.userImage.image = UIImage(data: data)
                print("Not data")
                return
            }
        }
        
        let fetchOperation = FetchOperation(contact: contact)
        let storeCacheData = BlockOperation {
            if let fetchOp = fetchOperation.imageData {
                print("No Fetch Op")
                self.cache.setValue(value: fetchOp, key: contact.email)
            }
        }
        let completeOp = BlockOperation {
            defer {
                self.operations.removeValue(forKey: contact.email)
            }
            if let currentPath = self.tableView.indexPath(for: cell), currentPath != indexPath {
                print("No currentPath")
                return
            }
            if let imageData = fetchOperation.imageData {
                      cell.userImage.image = UIImage(data: imageData)
                  }
            
        }

        storeCacheData.addDependency(fetchOperation)
        completeOp.addDependency(fetchOperation)
        
        photoFetchQueue.addOperations([fetchOperation, storeCacheData], waitUntilFinished: false)
        OperationQueue.main.addOperations([completeOp], waitUntilFinished: false)
        
        self.operations.updateValue(fetchOperation, forKey: contact.email)
        operations[contact.email] = fetchOperation
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        loadStuffInCell(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let fetchOperation = contacts[indexPath.row]
        guard let operation = operations[fetchOperation.email] else { return }
        operation.cancel()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let destinationVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.networkingController = networkingController
                destinationVC.contact = contacts[indexPath.row]
            }
        }
    }

}
