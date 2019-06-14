//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Ryan Murphy on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
        
        
        let imageFetchQueue = OperationQueue()
        let cache = Cache<String, Data>()
        let largeImageCache = Cache<String, Data>()
        var fetchOperations: [String: FetchThumbnailImageOperation] = [:]
        let networkController = NetworkController()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            networkController.fetchUsers { (error) in
                if let error = error {
                    NSLog("Error fetching users: \(error)")
                    print("Error fetching users")
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
//            print("fixedCell")
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let user = networkController.users[indexPath.row]
            
            let fetchOp = fetchOperations[user.name.first + user.name.last]
            fetchOp?.cancel()
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowSegue" {
                guard let detailVC = segue.destination as? UsersDetailViewController,
                    let index = tableView.indexPathForSelectedRow
                    else { return }
                detailVC.user = networkController.users[index.row]
                detailVC.cache = largeImageCache
            }
        }
        
        func loadImage(for cell: UITableViewCell, at indexPath: IndexPath) {
            
            let user = networkController.users[indexPath.row]
            
            if let cachedValue = self.cache.value(for: user.phone) {
                let image = UIImage(data: cachedValue)
                cell.imageView?.image = image
                return
            }
            
            let fetchThumbnailImageOperation = FetchThumbnailImageOperation(user: user)
            
            let cacheOperation = BlockOperation {
                guard let image = fetchThumbnailImageOperation.imageData else { return }
                self.cache.cache(value: image, for: user.phone)
            }
            
            let addImageOperation = BlockOperation {
                
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                
                if let image = fetchThumbnailImageOperation.imageData {
                    cell.imageView?.image = UIImage(data: image)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            
            cacheOperation.addDependency(fetchThumbnailImageOperation)
            
            addImageOperation.addDependency(fetchThumbnailImageOperation)
            
            imageFetchQueue.addOperation(fetchThumbnailImageOperation)
            imageFetchQueue.addOperation(cacheOperation)
            
            OperationQueue.main.addOperation(addImageOperation)
            
            fetchOperations[user.name.first + user.name.last] = fetchThumbnailImageOperation
        }
        
//    @IBAction func addButtonTapped(_ sender: Any) {
//        
//    }
//    
    }

