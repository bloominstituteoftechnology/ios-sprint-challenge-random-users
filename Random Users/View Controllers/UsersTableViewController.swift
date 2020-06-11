//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Dahna on 6/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let usersClient = UserClient()
    let cache = Cache<URL, Data>()
    var fetchOperation: [URL : FetchPhotoOperation] = [:]
    let photoFetchQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersClient.fetchUsers { error in
            if let error = error {
                NSLog("Error fetching Users from server: \(error)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersClient.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }

        let user = usersClient.users[indexPath.row]
        cell.user = user
        loadImage(forCell: cell , forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let user = usersClient.users[indexPath.row]
        guard let operation = fetchOperation[user.picture.thumbnail] else { return }
        operation.cancel()
    }
    
       private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
            
        let user = usersClient.users[indexPath.row]
        let url = user.picture.thumbnail
            
        if let imageData = cache.value(for: url) {
            let image = UIImage(data: imageData)
            cell.userImageView.image = image
        }
            
        let fetchOp = FetchPhotoOperation(user: user)
        
        let storeData = BlockOperation {
            guard let data = fetchOp.imageData else { return }
            self.cache.cache(value: data, for: url)
        }
            let completionOperation = BlockOperation {
                defer {
                    self.fetchOperation.removeValue(forKey: user.picture.thumbnail)
                }
                
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                
                guard let imageData = fetchOp.imageData else { return }
                cell.userImageView.image = UIImage(data: imageData)
            }
            
            storeData.addDependency(fetchOp)
            completionOperation.addDependency(fetchOp)
            
            photoFetchQueue.addOperation(fetchOp)
            photoFetchQueue.addOperation(storeData)
            OperationQueue.main.addOperation(completionOperation)
            
            fetchOperation[user.picture.thumbnail] = fetchOp
        }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.user = usersClient.users[indexPath.row]
        }
    }
}
