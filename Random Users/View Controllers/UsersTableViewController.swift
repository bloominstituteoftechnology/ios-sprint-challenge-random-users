//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Stephanie Bowles on 8/15/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    
    let networkController = NetworkController()
    let cache = Cache<String, Data>()
    let picFetchQueue = OperationQueue()
    var operations = [String: Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.networkController.fetchUsers { (error) in
            if let error = error {
                NSLog("error fetching users: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
       
    }

    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.networkController.users.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        self.loadPic(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    private func loadPic(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let userReference = self.networkController.users[indexPath.item]
        
        if let cachedData = self.cache.value(key: userReference.name) {
            cell.imageView?.image = UIImage(data: cachedData)
            cell.textLabel?.text = userReference.name
            return
                
            }
        
        let fetchPictureOperation = FetchImageOperation(user: userReference)
        
        let cachedOperation = BlockOperation {
            if let data = fetchPictureOperation.imageData {
                self.cache.cache(value: data, for: userReference.name)
            }
            
        }
        
        let checkReuseOperation = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            if let imageData = fetchPictureOperation.imageData {
                cell.imageView?.image = UIImage(data: imageData)
                cell.textLabel?.text = userReference.name
            }
        }
        
        cachedOperation.addDependency(fetchPictureOperation)
            checkReuseOperation.addDependency(fetchPictureOperation)
        picFetchQueue.addOperation(fetchPictureOperation)
        picFetchQueue.addOperation(cachedOperation)
        OperationQueue.main.addOperation(checkReuseOperation)
        self.operations[userReference.name] = fetchPictureOperation
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let userReference = self.networkController.users[indexPath.item]
        guard let fetchOperation = self.operations[userReference.name]
            else { NSLog("error cancelling photo request"); return}
        fetchOperation.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let detailVC = segue.destination as? UserDetailViewController,
            let index = tableView.indexPathForSelectedRow
                else {return}
            detailVC.user = networkController.users[index.row]
        }
    }
 

}
