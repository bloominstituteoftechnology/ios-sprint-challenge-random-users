//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        networkController.fetchUsers { (error) in
            if let error = error {
                NSLog("Error fecthing users: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let name = networkController.users[indexPath.row].name
        
        cell.textLabel?.text = "\(name.title.capitalized) \(name.first.capitalized) \(name.last.capitalized)"
    
        loadImage(for: cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = networkController.users[indexPath.row]
        let fetchOp = fetchOperations[user.name.first + user.name.last]
        fetchOp?.cancel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let detailVC = segue.destination as? UserDetailViewController,
            let index = tableView.indexPathForSelectedRow
            else { return }
            detailVC.user = networkController.users[index.row]
        }
    }
    
    func loadImage(for cell: UITableViewCell, at indexPath: IndexPath) {
        
        let user = networkController.users[indexPath.row]
        
        let fetchThumbnailImageOperation = FetchThumbnailImageOperation(user: user)
        
        let addImageOperation = BlockOperation {
            
            if let image = fetchThumbnailImageOperation.imageData {
                cell.imageView?.image = UIImage(data: image)
            }
        }
        
        addImageOperation.addDependency(fetchThumbnailImageOperation)
        
        imageFetchQueue.addOperation(fetchThumbnailImageOperation)
        OperationQueue.main.addOperation(addImageOperation)
        
        fetchOperations[user.name.first + user.name.last] = fetchThumbnailImageOperation
    }
    
    let networkController = NetworkController()
    
    var fetchOperations: [String: FetchThumbnailImageOperation] = [:]
    
    let imageFetchQueue = OperationQueue()
}
