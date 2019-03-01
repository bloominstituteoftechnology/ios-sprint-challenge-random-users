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
                NSLog("Erroring fetching users: \(error)")
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
        let user = networkController.users[indexPath.row]
        
        cell.textLabel?.text = "\(user.title.capitalized) \(user.first.capitalized) \(user.last.capitalized)"
    
        loadImage(for: cell, at: indexPath)
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    }
    
    let networkController = NetworkController()
    
    let imageFetchQueue = OperationQueue()
}
