//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Chris Dobek on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var userController = UserController()
    var cache = Cache<String, Data>()
    private var photoFetchQueue = OperationQueue()
    var operation = [UUID: Operation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUserFromServer() { error in
            if let error = error {
                NSLog("Error fetching \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell ?? UserTableViewCell()
        
        cell.user = userController.users[indexPath.row]
        loadImages(for: cell, forItemAt: indexPath)
       
        return cell
    }
    
    private func loadImages(for cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        if let cache = cache.value(for: user.id.uuidString) {
            cell.thumbnail.image = UIImage(data: cache)
            return
        } else {
            let fetchPhotoOperation = FetchPhotoOperation(user: user, imageIsThumbnail: true)
            let cacheImageData = BlockOperation {
                if let imageData = fetchPhotoOperation.imageData {
                    self.cache.cache(value: imageData, for: user.id.uuidString)
                } else { return }
            }
            let setCellThumbnail = BlockOperation {
                DispatchQueue.main.async {
                    if self.tableView.indexPath(for: cell) == indexPath {
                        if let imageData = fetchPhotoOperation.imageData {
                            cell.thumbnail.image = UIImage(data: imageData)
                        } else { return }
                    } else { return }
                }
            }
            cacheImageData.addDependency(fetchPhotoOperation)
            setCellThumbnail.addDependency(fetchPhotoOperation)
            photoFetchQueue.addOperations([fetchPhotoOperation, cacheImageData, setCellThumbnail], waitUntilFinished: false)
            operation[user.id] = fetchPhotoOperation
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let detailVC = segue.destination as? DetailViewController,
                let indexpath = tableView.indexPathForSelectedRow else {return}
            detailVC.user = userController.users[indexpath.row]
        }
    }
    
}
