//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by David Wright on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    // MARK: - Properties

    //let userController = UserController()
    
    var users = [User]() {
        didSet {
            DispatchQueue.main.async { self.tableView?.reloadData() }
        }
    }
    
    private let client = RandomUserClient()
    private var cache = Cache<URL, UIImage>()
    private let fetchPictureQueue = OperationQueue()
    private var fetchPictureOperations = [URL: Operation]()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        client.fetchRandomUsers { users, error in
            guard error == nil, let users = users else {
                NSLog("Error fetching users: \(error!)")
                return
            }
            self.users = users
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UsersTableViewCell ?? UsersTableViewCell()
        
        let user = users[indexPath.row]
        cell.user = user
        
        let thumbnailURL = user.picture.thumbnail
        loadThumbnail(at: thumbnailURL, forCell: cell, forRowAt: indexPath, isThumbnail: true)
        
        let fullSizePictureURL = user.picture.large
        cacheImage(at: fullSizePictureURL, forCell: cell, forRowAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let thumbnailURL = users[indexPath.row].picture.thumbnail
        if let operation = fetchPictureOperations[thumbnailURL] {
            operation.cancel()
        }
        
        let fullsizePictureURL = users[indexPath.row].picture.large
        if let operation = fetchPictureOperations[fullsizePictureURL] {
            operation.cancel()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowUserDetailSegue",
            let detailVC = segue.destination as? UserDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let user = users[indexPath.row]
        detailVC.user = user
        
        let fullSizePictureURL = user.picture.large
        loadfullSizePicture(at: fullSizePictureURL, forDetailVC: detailVC)
    }
    
    // MARK: - Private Methods
    
    private func loadThumbnail(at url: URL, forCell cell: UsersTableViewCell, forRowAt indexPath: IndexPath, isThumbnail: Bool = false) {
        
        if let picture = cache.value(for: url) {
            // Load image from cache
            DispatchQueue.main.async { cell.thumbnailImageView.image = picture }
            return
        }

        // Set up operations
        let fetchPictureOperation = FetchPictureOperation(imageURL: url)
        
        let cacheStoreOperation = BlockOperation {
            if let imageData = fetchPictureOperation.imageData,
                let picture = UIImage(data: imageData) {
                self.cache.cache(value: picture, for: url)
            }
        }
        
        let setImageOperation = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell) {
                guard currentIndexPath == indexPath else { return }
            }
            
            if let imageData = fetchPictureOperation.imageData,
                let picture = UIImage(data: imageData) {
                DispatchQueue.main.async { cell.thumbnailImageView.image = picture }
            }
        }
        
        // Add dependencies and queue priorities
        cacheStoreOperation.addDependency(fetchPictureOperation)
        setImageOperation.addDependency(fetchPictureOperation)
        
        fetchPictureOperation.queuePriority = .high
        cacheStoreOperation.queuePriority = .high
        setImageOperation.queuePriority = .high
        
        // Start operations
        fetchPictureQueue.addOperations([fetchPictureOperation, cacheStoreOperation], waitUntilFinished: false) // false = async
        OperationQueue.main.addOperations([setImageOperation], waitUntilFinished: false)
        fetchPictureOperations[url] = fetchPictureOperation
    }
    
    private func cacheImage(at url: URL, forCell cell: UsersTableViewCell, forRowAt indexPath: IndexPath, isThumbnail: Bool = false) {
        guard cache.value(for: url) == nil else { return }

        // Set up operations
        let fetchPictureOperation = FetchPictureOperation(imageURL: url)
        
        let cacheStoreOperation = BlockOperation {
            if let imageData = fetchPictureOperation.imageData,
                let picture = UIImage(data: imageData) {
                self.cache.cache(value: picture, for: url)
            }
        }
        
        // Add dependencies and queue priorities
        cacheStoreOperation.addDependency(fetchPictureOperation)
        if isThumbnail {
            fetchPictureOperation.queuePriority = .high
            cacheStoreOperation.queuePriority = .high
        }
        
        // Start operations
        fetchPictureQueue.addOperations([fetchPictureOperation, cacheStoreOperation], waitUntilFinished: false) // false = async
        fetchPictureOperations[url] = fetchPictureOperation
    }
    
    private func loadfullSizePicture(at url: URL, forDetailVC detailVC: UserDetailViewController) {
        
        if let picture = cache.value(for: url) {
            // Load image from cache
            DispatchQueue.main.async { detailVC.imageView.image = picture }
            return
        }

        // Set up operations
        let fetchPictureOperation = FetchPictureOperation(imageURL: url)
        
        let cacheStoreOperation = BlockOperation {
            if let imageData = fetchPictureOperation.imageData,
                let picture = UIImage(data: imageData) {
                self.cache.cache(value: picture, for: url)
            }
        }
        
        let setImageOperation = BlockOperation {
            if let imageData = fetchPictureOperation.imageData,
                let picture = UIImage(data: imageData) {
                DispatchQueue.main.async { detailVC.imageView.image = picture }
            }
        }
        
        // Add dependencies and queue priorities
        cacheStoreOperation.addDependency(fetchPictureOperation)
        setImageOperation.addDependency(fetchPictureOperation)
        
        fetchPictureOperation.queuePriority = .veryHigh
        cacheStoreOperation.queuePriority = .veryHigh
        setImageOperation.queuePriority = .veryHigh
        
        // Start operations
        fetchPictureQueue.addOperations([fetchPictureOperation, cacheStoreOperation], waitUntilFinished: false) // false = async
        OperationQueue.main.addOperations([setImageOperation], waitUntilFinished: false)
        fetchPictureOperations[url] = fetchPictureOperation
    }
}
