//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Christopher Aronson on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    var listOfUsers: RandomUser?
    var cache = Cache<String, Data>()
    var fetchDictionary: [String : FetchThumbnail] = [:]

    override func viewDidLoad() {
        
        let userFetchQueue = OperationQueue()
        
        let getRandomUsersOp = RandomUserController()
        
        let loadUsersToTable = BlockOperation {
            self.listOfUsers = getRandomUsersOp.users
        }
        
        let reloadTableview = BlockOperation {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        loadUsersToTable.addDependency(getRandomUsersOp)
        reloadTableview.addDependency(loadUsersToTable)
        
        userFetchQueue.addOperations([getRandomUsersOp, loadUsersToTable, reloadTableview], waitUntilFinished: false)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfUsers?.results.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        guard let userForThisCell = listOfUsers?.results[indexPath.row] else { return UITableViewCell()}

        cell.textLabel?.text = "\(userForThisCell.name.title) \(userForThisCell.name.first) \(userForThisCell.name.last)"
        loadThumbnail(forCell: cell, forItemAt: indexPath)
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let localUser = listOfUsers?.results[indexPath.row] else { return }
        
        let fullName = "\(localUser.name.title) \(localUser.name.first) \(localUser.name.last)"
        if let operation = fetchDictionary[fullName] {
            operation.cancel()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! UserDetailViewController
                controller.localUser = listOfUsers?.results[indexPath.row]
            }
        }
    }
    
    private func loadThumbnail(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let localUser = listOfUsers?.results[indexPath.row],
        let thumbnaillUrl = URL(string: (localUser.picture.thumbnail))
        else { return }
        
        var imageData: Data?
//        let indexPatchForCell = indexPath
        let fullName = "\(localUser.name.title) \(localUser.name.first) \(localUser.name.last)"
        let lock = NSLock()
        
        if let imageData = cache.value(for: fullName) {
            cell.imageView!.image = UIImage(data: imageData)
        } else {
            
            let fetchThumbnailOp = FetchThumbnail(url: thumbnaillUrl)
            
            let getDataOp = BlockOperation {
                lock.lock()
                imageData = fetchThumbnailOp.thumbnailData
                lock.unlock()
            }
            
            let cacheImageOp = BlockOperation {
                lock.lock()
                guard let data = imageData else { return }
                self.cache.cache(value: data, for: fullName)
                lock.unlock()
            }
            
            let displayOp = BlockOperation {
                lock.lock()
                if fetchThumbnailOp.thumbnailURL?.absoluteString == localUser.picture.thumbnail {
                    DispatchQueue.main.async {
                        guard let data = imageData else { return }
                        cell.imageView!.image = UIImage(data: data)
                    }
                }
                lock.unlock()
            }
            
            getDataOp.addDependency(fetchThumbnailOp)
            cacheImageOp.addDependency(getDataOp)
            displayOp.addDependency(getDataOp)
            fetchDictionary[fullName] = fetchThumbnailOp
            
            let thumbnailQueue = OperationQueue()
            thumbnailQueue.maxConcurrentOperationCount = 1
            thumbnailQueue.addOperations([fetchThumbnailOp, getDataOp, cacheImageOp, displayOp], waitUntilFinished: false)
        }
    }

}
