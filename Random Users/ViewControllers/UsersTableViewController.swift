//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jon Bash on 2019-12-06.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    typealias ImageDataCache = Cache<Int, Data>
    
    private var users = [RandomUser]()
    private var apiController = APIController()
    
    lazy private var thumbnailCache = ImageDataCache()
    lazy private var fullImageCache = ImageDataCache()
    
    lazy private var thumbnailFetchQueue = OperationQueue()
    lazy private var thumbnailFetchOps = Cache<Int, ImageFetchOperation>()
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell
            else { return UITableViewCell() }
        
        cell.user = users[indexPath.row]
        loadThumbnail(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UserTableViewCell else { return }
        cell.userImageView.image = nil
        thumbnailFetchOps[indexPath.row]?.cancel()

    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        for (_, op) in thumbnailFetchOps {
            op.cancel()
        }
        thumbnailFetchOps.clear()
        thumbnailCache.clear()
        users = []
        tableView.reloadData()
        apiController.fetchUsers(completion: didFetchUsers(with:))
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetailSegue" {
            guard let detailVC = segue.destination as? UserDetailViewController,
                let index = tableView.indexPathForSelectedRow?.row
                else { return }
            
            if users[index].imageInfo.fullImageData == nil && detailVC.imageFetchOp == nil {
                fetchImage(forUserAtIndex: index, detailVC)
            }
            detailVC.user = users[index]
        }
    }
    
    // MARK: - Private Methods
    
    private func didFetchUsers(with result: Result<[RandomUser], Error>) {
        do {
            users = try result.get()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }
    
    private func loadThumbnail(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let imageInfo = users[indexPath.row].imageInfo
        
        // check first if image is already cached
        if let imageData = thumbnailCache[indexPath.row] {
            cell.userImageView.image = UIImage(data: imageData)
            return
        }
        
        // otherwise, fetch the image
        let thumbnailFetchOp = ImageFetchOperation(imageInfo)
        let storeImageToCacheOp = BlockOperation {
            let fetchOp = self.thumbnailFetchOps[indexPath.row]
            guard let imageData = fetchOp?.imageData else {
                return
            }
            self.users[indexPath.row].imageInfo.thumbnailData = imageData
            self.thumbnailCache[indexPath.row] = imageData
        }
        let checkCellReuseOp = BlockOperation {
            if cell.user != self.users[indexPath.row] {
                return
            }
            if let imageData = self.thumbnailCache[indexPath.row],
                let image = UIImage(data: imageData)
            {
                let fetchOp = self.thumbnailFetchOps[indexPath.row]
                fetchOp?.cancel()
                cell.userImageView.image = image
            }
        }
        
        checkCellReuseOp.addDependency(storeImageToCacheOp)
        storeImageToCacheOp.addDependency(thumbnailFetchOp)
        
        thumbnailFetchQueue.addOperations([thumbnailFetchOp, storeImageToCacheOp], waitUntilFinished: false)
        OperationQueue.main.addOperation(checkCellReuseOp)
        
        thumbnailFetchOps[indexPath.row] = thumbnailFetchOp
    }
    
    private func fetchImage(forUserAtIndex index: Int, _ detailVC: UserDetailViewController) {
        let imageFetchOp = ImageFetchOperation(users[index].imageInfo, forFullImage: true)
        let imageSetOp = BlockOperation {
            if let imageData = imageFetchOp.imageData {
                self.fullImageCache[index] = imageData
                DispatchQueue.main.async {
                    detailVC.userImageView.image = UIImage(data: imageData)
                }
            }
        }
        imageSetOp.addDependency(imageFetchOp)
        
        detailVC.operationQueue.addOperations([imageFetchOp, imageSetOp], waitUntilFinished: false)
        detailVC.imageFetchOp = imageFetchOp
    }
}
