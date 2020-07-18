//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Bohdan Tkachenko on 7/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    let reuseIdentifier = "UserCell"
    let apiController = APIController()
    let cache = Cache<String, Data>()
    private var fetchQueue = OperationQueue()
    private var fetchUserOperations: [String : FetchUsers] = [ : ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiController.user.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = apiController.user[indexPath.item]
        fetchUserOperations[user.name]?.cancel()
    }
    
    func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = apiController.user[indexPath.item]
        let fetchOperation = FetchUsers(person: user)
        
        if let cacheData = cache.value(for: user.name), let image = UIImage(data: cacheData) {
            cell.imageView?.image = image
            cell.textLabel?.text = user.name
            return
        }
        
        let cacheOperation = BlockOperation {
            if let data = fetchOperation.imageData {
                self.cache.cache(value: data, for: user.name)
            }
        }
        cacheOperation.addDependency(fetchOperation)
        
        let updateOperation = BlockOperation {
            defer { self.fetchUserOperations.removeValue(forKey: user.name)}
            
            if let currentIndexPath = self.tableView?.indexPath(for: cell), currentIndexPath != indexPath {
                return
            }
            if let imageData = fetchOperation.imageData {
                cell.imageView?.image = UIImage(data: imageData)
                cell.textLabel?.text = user.name
            }
        }
        
        updateOperation.addDependency(fetchOperation)
        fetchQueue.addOperation(fetchOperation)
        fetchQueue.addOperation(cacheOperation)
        OperationQueue.main.addOperation(updateOperation)
        self.fetchUserOperations[user.name] = fetchOperation
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToDetailVC":
            guard let detailVC = segue.destination as? DetailViewController, let indexPath = self.tableView.indexPathForSelectedRow else { return }
            detailVC.user = apiController.user[indexPath.row]
        default:
            break
        }
    }
}
