//
//  TableViewController.swift
//  Random Users
//
//  Created by Shawn James on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networking.fetchUsers {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        networking.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let user = networking.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadImage(forCell: cell, forItemAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let id = networking.users[indexPath.row].id
        if let operation = operationsDictionary[id] { operation.cancel() }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSeg" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let user = networking.users[indexPath.row]
            detailViewController.user = user
        }
    }
    
    // MARK: - Properties
    
    let networking = Networking()
    private let photoFetchQueue = OperationQueue()
    let cache = Cache<UUID,Data>()
    var operationsDictionary = [UUID : Operation]()
    
    // MARK: - Methods
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TableViewCell else { return }
        let user = networking.users[indexPath.row]
        if let cache = cache.value(for: user.id) {
            cell.thumbnail.image = UIImage(data: cache)?.circle
            return
        } else {
            let fetchPhotoOperation = FetchPhotoOperation(user: user, imageIsThumbnail: true)
            let cacheImageData = BlockOperation {
                if let imageData = fetchPhotoOperation.imageData {
                    self.cache.cache(value: imageData, for: user.id)
                } else { return }
            }
            let setCellThumbnail = BlockOperation {
                DispatchQueue.main.async {
                    if self.tableView.indexPath(for: cell) == indexPath {
                        if let imageData = fetchPhotoOperation.imageData {
                            cell.thumbnail.image = UIImage(data: imageData)?.circle
                        } else { return }
                    } else { return }
                }
            }
            cacheImageData.addDependency(fetchPhotoOperation)
            setCellThumbnail.addDependency(fetchPhotoOperation)
            photoFetchQueue.addOperations([fetchPhotoOperation, cacheImageData, setCellThumbnail], waitUntilFinished: false)
            operationsDictionary[user.id] = fetchPhotoOperation
        }
    }
    
}
