//
//  UserProfilesTableViewController.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserProfileTableViewController: UITableViewController {
    // MARK: - Properties
    
    var users: [User] = []
    var userImages: [String : Data] = [:]
    var networkClient = NetworkClient()
    private var cache = Cache<String, User>()
    private var imageOperationQueue = OperationQueue()
    private var imageFetchOperations: [String : ImageFetchOperation] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let fetchOperation = imageFetchOperations[user.id]
        fetchOperation?.cancel()
    }
    
    //Helper Method
    private func loadUserImage(for cell: UserProfileTableViewCell, atIndexPath indexPath: IndexPath) {
        var user = users[indexPath.row]
        
        if let cachedUser = cache.value(for: user.id) {
            cell.userLabel?.text = cachedUser.name
            if let picture = cachedUser.picture {
                cell.userImageView?.image = UIImage(data: picture)
            }
            return
        }
        
        
        let fetchOperation = ImageFetchOperation(with: user)
        imageFetchOperations[user.id] = fetchOperation
        
        let cacheOperation = BlockOperation {
            if let image = fetchOperation.imageData {
                self.userImages[user.id] = image
            }
            self.cache.cache(for: user.id, with: user)
        }
        
        
        let updateUIOperation = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                NSLog("Cell instance has been reused for a different indexPath")
                return
            }
            
            if let image = fetchOperation.imageData {
                user.picture = image
                cell.userImageView?.image = UIImage(data: image)
            }
            cell.userLabel?.text = user.name
        }
        
        cacheOperation.addDependency(fetchOperation)
        updateUIOperation.addDependency(fetchOperation)
        
        imageOperationQueue.addOperation(fetchOperation)
        imageOperationQueue.addOperation(cacheOperation)
        OperationQueue.main.addOperation(updateUIOperation)
        
    }
}
// MARK: - Navigation

extension UserProfileTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            let detailVC = segue.destination as! UserProfileDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            detailVC.user = user
            detailVC.userImage = userImages[user.id]
        }
    }
}
