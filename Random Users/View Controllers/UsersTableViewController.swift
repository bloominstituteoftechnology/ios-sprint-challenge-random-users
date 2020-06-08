//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Cody Morley on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    //MARK: - Types -
    private enum Segues: String {
        case detail = "DetailSegue"
    }
    
    private enum Cells: String {
        case user = "UserCell"
    }
    
    
    //MARK: - Properties -
    let apiController = APIController()
    var thumbnailCache = Cache<UUID, Data>()
    var thumbnailFetchQueue = OperationQueue()
    var operations: [UUID : Operation] = [:]
    var fetchedUsers: [User] = [] {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        apiController.getUsers { result in
            do {
                let fetchResult = try result.get()
                self.fetchedUsers = fetchResult
            } catch {
                NSLog("Something went terribly wrong setting the result from initial user fetch. Here's some more info: \(error) \(error.localizedDescription)")
                return
            }
        }
        super.viewDidLoad()
    }
    
    
    // MARK: - Table View Data Source -
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.user.rawValue, for: indexPath) as? UserTableViewCell else {
            fatalError("Sorry but a cell with identifier \(Cells.user.rawValue) couldn't be dequeued.")
        }
        
        let user = fetchedUsers[indexPath.row]
        cell.user = user
        cell.userName.text = user.name
        loadThumbnail(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = fetchedUsers[indexPath.row]
        operations[user.id]?.cancel()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.detail.rawValue {
            guard let detailVC = segue.destination as? UserDetailViewController, let index = tableView.indexPathForSelectedRow else { return }
            detailVC.user = fetchedUsers[index.row]
        }
    }
    
    
    //MARK: - Methods -
    private func loadThumbnail(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        guard let user = cell.user else { return }
        
        if let cachedThumbnail = thumbnailCache.value(for: user.id) {
            cell.userThumbnail.image = UIImage(data: cachedThumbnail)
        }
        
        let fetchThumbnail = FetchThumbnailOperation(user: user)
        let cacheThumbnail = BlockOperation {
            if let fetchedThumbnail = fetchThumbnail.imageData {
                self.thumbnailCache.cache(for: user.id, value: fetchedThumbnail)
            }
        }
        let finishThumbnail = BlockOperation {
            defer { self.operations.removeValue(forKey: user.id) }
            if let currentIndex = self.tableView.indexPath(for: cell), currentIndex != indexPath {
                print("Did not load thumbnail before thumbnail passed - caching.")
                return
            }
            if let fetchedThumbnail = fetchThumbnail.imageData {
                cell.userThumbnail.image = UIImage(data: fetchedThumbnail)
            }
        }
        
        cacheThumbnail.addDependency(fetchThumbnail)
        finishThumbnail.addDependency(fetchThumbnail)
        thumbnailFetchQueue.addOperations([fetchThumbnail, cacheThumbnail], waitUntilFinished: false)
        OperationQueue.main.addOperation(finishThumbnail)
        operations[user.id] = fetchThumbnail
    }
    

}
