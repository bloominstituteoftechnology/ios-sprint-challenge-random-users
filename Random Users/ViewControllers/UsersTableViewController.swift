//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Gerardo Hernandez on 4/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    
    //MARK: - Properties
    var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    private let fetchController = FetchRandomUsersController()
    private var cache = Cache<URL, UIImage>()
    private let fetchPictureQueue = OperationQueue()
    private var fetchPictureOps = [URL: Operation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fetchController.fetchRandomUsers { users, error in
            guard error == nil,
            let users = users else { NSLog("Error fetching users: \(error!)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as? UsersTableViewCell ?? UsersTableViewCell()
        
        let user = users[indexPath.row]
        cell.user = user
        
        let thumbnailURL = user.picture.thumbnail
        loadThumbnail(at: thumbnailURL, forCell: cell, forRowAt: indexPath, isThumbnail: true)
        
        let largePictureURL = user.picture.large
        cacheImage(at: largePictureURL, forCell: cell, forRowAt: indexPath)
     

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          let thumbnailURL = users[indexPath.row].picture.thumbnail
          if let operation = fetchPictureOps[thumbnailURL] {
              operation.cancel()
          }
          
          let fullsizePictureURL = users[indexPath.row].picture.large
          if let operation = fetchPictureOps[fullsizePictureURL] {
              operation.cancel()
          }
      }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          guard segue.identifier == "UserDetailShowSegue",
                 let detailVC = segue.destination as? UserDetailViewController,
                 let indexPath = tableView.indexPathForSelectedRow else { return }
             
             let user = users[indexPath.row]
             detailVC.user = user
             
             let largePictureURL = user.picture.large
             loadfullSizePicture(at: largePictureURL, forDetailVC: detailVC)
    }

    
    // MARK: - Private Methods
        
        private func loadThumbnail(at url: URL, forCell cell: UsersTableViewCell, forRowAt indexPath: IndexPath, isThumbnail: Bool = false) {
            
            if let picture = cache.value(for: url) {
                // Load image from cache
                DispatchQueue.main.async { cell.userThumbnailImageView.image = picture }
                return
            }

            
            let fetchPictureOp = FetchPictureOp(imageURL: url)
            
            let cacheStoreOp = BlockOperation {
                if let imageData = fetchPictureOp.imageData,
                    let picture = UIImage(data: imageData) {
                    self.cache.cache(value: picture, for: url)
                }
            }
            
            let setImageOp = BlockOperation {
                if let currentIndexPath = self.tableView.indexPath(for: cell) {
                    guard currentIndexPath == indexPath else { return }
                }
                
                if let imageData = fetchPictureOp.imageData,
                    let picture = UIImage(data: imageData) {
                    DispatchQueue.main.async { cell.userThumbnailImageView.image = picture }
                }
            }
            
           
            cacheStoreOp.addDependency(fetchPictureOp)
            setImageOp.addDependency(fetchPictureOp)
            
            fetchPictureOp.queuePriority = .high
            cacheStoreOp.queuePriority = .high
            setImageOp.queuePriority = .high
            
       
            fetchPictureQueue.addOperations([fetchPictureOp, cacheStoreOp], waitUntilFinished: false) // false = async
            OperationQueue.main.addOperations([setImageOp], waitUntilFinished: false)
            fetchPictureOps[url] = fetchPictureOp
        }
        
        private func cacheImage(at url: URL, forCell cell: UsersTableViewCell, forRowAt indexPath: IndexPath, isThumbnail: Bool = false) {
            guard cache.value(for: url) == nil else { return }

          
            let fetchPictureOp = FetchPictureOp(imageURL: url)
            
            let cacheStoreOp = BlockOperation {
                if let imageData = fetchPictureOp.imageData,
                    let picture = UIImage(data: imageData) {
                    self.cache.cache(value: picture, for: url)
                }
            }
            
            // Add dependencies
            cacheStoreOp.addDependency(fetchPictureOp)
            if isThumbnail {
                fetchPictureOp.queuePriority = .high
                cacheStoreOp.queuePriority = .high
            }
            
            // Start operations
            fetchPictureQueue.addOperations([fetchPictureOp, cacheStoreOp], waitUntilFinished: false) // false = async
            fetchPictureOps[url] = fetchPictureOp
        }
        
        private func loadfullSizePicture(at url: URL, forDetailVC detailVC: UserDetailViewController) {
            
            if let picture = cache.value(for: url) {
               
                DispatchQueue.main.async { detailVC.imageView.image = picture }
                return
            }

            // Set up operations
            let fetchPictureOp = FetchPictureOp(imageURL: url)
            
            let cacheStoreOp = BlockOperation {
                if let imageData = fetchPictureOp.imageData,
                    let picture = UIImage(data: imageData) {
                    self.cache.cache(value: picture, for: url)
                }
            }
            
            let setImageOp = BlockOperation {
                if let imageData = fetchPictureOp.imageData,
                    let picture = UIImage(data: imageData) {
                    DispatchQueue.main.async { detailVC.imageView.image = picture }
                }
            }
            
            // Add dependencies and queue priorities
            cacheStoreOp.addDependency(fetchPictureOp)
            setImageOp.addDependency(fetchPictureOp)
            
            fetchPictureOp.queuePriority = .veryHigh
            cacheStoreOp.queuePriority = .veryHigh
            setImageOp.queuePriority = .veryHigh
            
            // Start operations
            fetchPictureQueue.addOperations([fetchPictureOp, cacheStoreOp], waitUntilFinished: false) // false = async
            OperationQueue.main.addOperations([setImageOp], waitUntilFinished: false)
            fetchPictureOps[url] = fetchPictureOp
    }
}
