//
//  TableViewController.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private let fetchingImageQueue = OperationQueue()
    private var fetchingImageOperations = [User : Operation]()
    static let userCell = "UserCell"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserModelController.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userItem = UserModelController.shared.users[indexPath.row]
        fetchingImageOperations[userItem]?.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToUserDetailViewController" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let detailVC = segue.destination as! DetailViewController
            detailVC.user = UserModelController.shared.users[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewController.userCell)
            else { return UITableViewCell() }
        
        let user = UserModelController.shared.users[indexPath.row]
        
        cell.textLabel?.text = "\(user.name)"
        if let cachedThumbnail = CachedImages.shared[thumbnail: user] {
            cell.imageView?.image = cachedThumbnail
        } else {
            
            let imageFetchOperation = ImageFetch(userImage: user, imageSize: .thumbnail)
            imageFetchOperation.completionBlock = { [weak imageOperation = imageFetchOperation] in
                CachedImages.shared[thumbnail: user] = imageOperation?.imageResults
            }
            let updateViewsOperation = BlockOperation {
                defer { self.fetchingImageOperations.removeValue(forKey: user) }
                
                if let operationIndexPath = self.tableView.indexPath(for: cell),
                    operationIndexPath != operationIndexPath {
                    return
                }
                cell.imageView?.image = imageFetchOperation.imageResults
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            updateViewsOperation.addDependency(imageFetchOperation)
            fetchingImageQueue.addOperation(imageFetchOperation)
            OperationQueue.main.addOperation(updateViewsOperation)
        }
        
        return cell
    }
    
    @IBAction func addUsers(_ sender: Any) {
        
        let fetchUsersOperation = UserFetch(amountOfUsers: 1000)
        let updateViewsOperation = BlockOperation {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let users = fetchUsersOperation.userResults else { return }
            UserModelController.shared.addUsers(addedUsers: users)
            self.tableView.reloadData()
        }
        
        updateViewsOperation.addDependency(fetchUsersOperation)
        fetchingImageQueue.addOperation(fetchUsersOperation)
        OperationQueue.main.addOperation(updateViewsOperation)
    }
}
