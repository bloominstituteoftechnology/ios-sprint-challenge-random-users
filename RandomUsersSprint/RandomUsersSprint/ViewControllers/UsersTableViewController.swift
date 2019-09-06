//
//  UsersTableViewController.swift
//  RandomUsersSprint
//
//  Created by Luqmaan Khan on 9/6/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    let userController = UserController()
    private var photoFetchQueue = OperationQueue()
    var cache = Cache<String, Data>()
    var storedFetchOperations = [String:FetchPhotoOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers { (error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {return UITableViewCell()}
        let user = userController.users[indexPath.row]
            if let cachedImage = cache.value(for: user.thumbnail.absoluteString) {
                cell.imageView!.image = UIImage(data: cachedImage)
            }
        
        cell.usersName.text = user.first
        cell.imageView?.image = nil
        let fetchImageOperation = FetchPhotoOperation(user: user)
        let storeDataInCache = BlockOperation {
            guard let receivedImageData = fetchImageOperation.imageData else {return}
            self.cache.cache(value: receivedImageData, for: user.thumbnail.absoluteString)
        }
        let setImage = BlockOperation {
           
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            guard let imageData = fetchImageOperation.imageData else {return}
            cell.thumbNail.image = UIImage(data: imageData)
        }
        storeDataInCache.addDependency(fetchImageOperation)
        setImage.addDependency(fetchImageOperation)
        photoFetchQueue.addOperation(fetchImageOperation)
        photoFetchQueue.addOperation(storeDataInCache)
        OperationQueue.main.addOperation(setImage)
        storedFetchOperations[user.thumbnail.absoluteString] = fetchImageOperation
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let operation = storedFetchOperations[user.thumbnail.absoluteString]
        operation?.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUser" {
            guard let detailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            let user = userController.users[indexPath.row]
            detailVC.user = user
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        userController.fetchUsers { (error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
