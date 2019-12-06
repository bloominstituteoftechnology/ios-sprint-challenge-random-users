//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Rick Wolter on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    
    
    // MARK: - Properties
    let client = RandomUsersClient()
    let cache = Cache<URL, Data>()
    var fetchOperation: [URL : FetchPhotoOperation] = [:]
    let photoFetchQueue = OperationQueue()
    let queue = DispatchQueue(label: "CancelOperationQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.fetchRandomUser { ( error ) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return client.savedUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as? RandomUserTableViewCell else { return UITableViewCell() }
        
        let user = client.savedUsers[indexPath.row]
        let name = "\(user.name.last),\(user.name.first)"
        cell.randomUserNameLabel.text = name
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = client.savedUsers[indexPath.row]
        let operation = fetchOperation[user.picture.large]
        queue.sync {
            operation?.cancel()
        }
    }
    
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = client.savedUsers[indexPath.row]
        let url = user.picture.large
        
        if let imageData = cache.value(for: url) {
            let image = UIImage(data: imageData)
            cell.randomUserThumbnailImage.image = image
            return
        }
        
        let fetchPhotoOperation = FetchPhotoOperation(user: user)
        
        let storeDataInCache = BlockOperation {
            guard let imageData = fetchPhotoOperation.imageData else { return }
            self.cache.cache(value: imageData, for: url)
        }
        
        let setImageAndName = BlockOperation {
            defer {
                self.fetchOperation.removeValue(forKey: user.picture.large)
            }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            
            guard let imageData = fetchPhotoOperation.imageData else { return }
            cell.randomUserThumbnailImage.image = UIImage(data: imageData)
        }
        
        storeDataInCache.addDependency(fetchPhotoOperation)
        setImageAndName.addDependency(fetchPhotoOperation)
        
        photoFetchQueue.addOperation(fetchPhotoOperation)
        photoFetchQueue.addOperation(storeDataInCache)
        OperationQueue.main.addOperation(setImageAndName)
        
        fetchOperation[user.picture.large] = fetchPhotoOperation
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let detailVC = segue.destination as? RandomUserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.user = client.savedUsers[indexPath.row]
        }
    }
    
    
}
