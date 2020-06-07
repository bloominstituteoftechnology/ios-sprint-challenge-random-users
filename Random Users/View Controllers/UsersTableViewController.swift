//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    //MARK: - Properties -
    let segueID = "UserDetailSegue"
    let apiController = APIController()
    let thumbnailCache = Cache<String, Data>()
    var thumbnailFetchQueue = OperationQueue()
    var operations: [String: Operation] = [:]
    var fetchedUsers = [User](){
        didSet{
            DispatchQueue.main.async { self.tableView?.reloadData() }
        }
    }
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.getUsers { result in
            do {
                let fetchedUsers = try result.get()
                self.fetchedUsers = fetchedUsers
            } catch {
                NSLog("There was an error retrieving user profiles: \(error) \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    // MARK: - Table View Datasource -
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? UserTableViewCell else { fatalError("Couldn't Dequeue cell of type \(UserTableViewCell.reuseIdentifier)") }
        
        cell.user = fetchedUsers[indexPath.row]
        cell.userNameLabel.text = cell.user?.name
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = fetchedUsers[indexPath.row]
        operations[user.phoneNumber]?.cancel()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == segueID {
            guard let detailVC = segue.destination as? UserDetailViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            detailVC.user = fetchedUsers[index.row]
        }
    }
    
    
    //MARK: - Methods -
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = fetchedUsers[indexPath.row]
        
        if let cachedData = thumbnailCache.value(for: user.phoneNumber) {
            cell.imageView?.image = UIImage(data: cachedData)
            return
        }
        
        let fetchThumbnail = FetchThumbnailOperation(user: user)
        let cacheThumbnail = BlockOperation {
            if let fetchedThumbnail = fetchThumbnail.imageData {
                self.thumbnailCache.cache(for: user.phoneNumber, value: fetchedThumbnail)
            }
        }
        let completeThumbnailOperations = BlockOperation {
            if let currentIndex = self.tableView.indexPath(for: cell),
                currentIndex != indexPath {
                NSLog("Finished image loading after cell had passed in view.")
                return
            }
            if let fetchedThumbnail = fetchThumbnail.imageData {
                cell.imageView?.image = UIImage(data: fetchedThumbnail)
            }
        }
        cacheThumbnail.addDependency(fetchThumbnail)
        completeThumbnailOperations.addDependency(fetchThumbnail)
        thumbnailFetchQueue.addOperations([fetchThumbnail, cacheThumbnail], waitUntilFinished: false)
        OperationQueue.main.addOperation(completeThumbnailOperations)
        operations[user.phoneNumber] = fetchThumbnail
    }
    

}
