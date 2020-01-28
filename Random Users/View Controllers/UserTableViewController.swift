//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var userController = UserController()
    var cache = Cache<String, UIImage>()
    var fetchOperationsReference: Dictionary<String, Operation> = [:]
    var photoFetchQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.fetchUsers(completion: { (error) in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }

        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    // Method cancels a data task that is working to load an image that has already been scrolled off-screen
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let friend = userController.results[indexPath.row]
        let dictionaryKey = friend.phone
        let taskToCancel = fetchOperationsReference[dictionaryKey]
        taskToCancel?.cancel()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendDetailSegue" {
            guard let friendDetailVC = segue.destination as? FriendDetailViewController else { return }
            if let indexPath = tableView.indexPathForSelectedRow {
                friendDetailVC.friend = userController.results[indexPath.row]
                friendDetailVC.userController = userController
            }
        }
    }
    
    // MARK: - Private Methods
    // The loadImage method is called from the cellForRowAt indexPath function. It takes the cell and index path provided and passes the current Friend to the table view cell. It also calls the FetchFriendsOperation to fetch the image and checks to see if the image has been cached or not. It cached, it retrieves it from cache, otherwise it fetches the image, puts it into cache, and passes the image to the table view cell.
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let friend = userController.results[indexPath.row]
        
        guard cache.value(for: friend.phone) == nil else {
            guard let cachedImage = cache.value(for: friend.phone) else { return }
            cell.friendThumbnail = cachedImage
            cell.friend = friend
            return
        }
        
        let fetchedFriendOperation = FetchFriendsOperation(friend: friend)
        fetchOperationsReference.updateValue(fetchedFriendOperation, forKey: friend.phone)
        
        let cacheNewImageOperation = BlockOperation {
            guard let image = fetchedFriendOperation.image else { return }
            self.cache.cache(value: image, key: friend.phone)
        }
        
        let checkCellReuseOperation = BlockOperation {
            DispatchQueue.main.async {
                let visibleCell = self.tableView.indexPathsForVisibleRows
                guard visibleCell!.contains(indexPath) else { return }
                guard let image = self.cache.value(for: friend.phone) else { return }
                cell.friendThumbnail = image
                cell.friend = friend
            }
        }
        
        cacheNewImageOperation.addDependency(fetchedFriendOperation)
        checkCellReuseOperation.addDependency(cacheNewImageOperation)
        
        photoFetchQueue.addOperations([fetchedFriendOperation, cacheNewImageOperation, checkCellReuseOperation], waitUntilFinished: false)
        
    }

}
