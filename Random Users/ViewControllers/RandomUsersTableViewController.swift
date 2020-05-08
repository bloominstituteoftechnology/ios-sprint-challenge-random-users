//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    private let userController = UserController()
    private let imageCache = Cache<Int, UIImage>()
   private let photoFetchQueue = OperationQueue()
    private var fetchOperations: [Int: FetchPhotoOperation] = [:]
    private var largePhotoCache = Cache<Int, UIImage>()
    private let largePhotoFetchQueue = OperationQueue()
    private var largePhotoFetchOperations: [Int: FetchPhotoOperation] = [:]
    
    private var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        userController.fetchRandomUsers { result in
            do {
                let users = try result.get()
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                if let error = error as? NetworkError {
                    NSLog("Error in getting users: \(error)")
                    return
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUserCell", for: indexPath) as? UsersTableViewCell ?? UsersTableViewCell()
    
        cell.user = users[indexPath.item]
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "DetailSegue" {
                if let userVC = segue.destination as? UsersDetailViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        userVC.user  = users[indexPath.row]
                        loadImage(UserDetailController: userVC, forItemAt: indexPath)
                        
                    }
                }
            }
        
    }
     
    
    
    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        
        cell.cellIndexPath = indexPath
        
        let cacheIndex = cell.cellIndexPath
        let imageThumbNail = users[cacheIndex.item].picture.thumbnail
        
        if let cacheImage = imageCache.value(for: cacheIndex.item) {
            cell.userImage.image = cacheImage
            return
        } else {
            let fetchedPhoto = FetchPhotoOperation(imageURL: URL(string: imageThumbNail)!)
            
            let cachePhotoData = BlockOperation {
                if let imageData = fetchedPhoto.imageData {
                    self.imageCache.cache(value: imageData, for: cacheIndex.item)
                }
            }
            
            let cellPhotoData = BlockOperation {
                if cacheIndex != cell.cellIndexPath {
                    return
                }
                if let image = fetchedPhoto.imageData {
                    DispatchQueue.main.async {
                        cell.userImage.image = image
                    }
                  
                }
                    
            }
            
            cachePhotoData.addDependency(fetchedPhoto)
            cellPhotoData.addDependency(fetchedPhoto)
            
            photoFetchQueue.addOperations([cachePhotoData, cellPhotoData, fetchedPhoto], waitUntilFinished: false)
      
        }
    }
    
    private func loadImage(UserDetailController vc: UsersDetailViewController, forItemAt indexPath: IndexPath) {
        
     
        let largePhotoURL = users[indexPath.item].picture.large

        if let image = largePhotoCache.value(for: indexPath.item) {
            vc.userImage?.image = image
            return
        }
        
    
        let fetchOperation = FetchPhotoOperation(imageURL: URL(string: largePhotoURL)!)
        largePhotoFetchOperations[indexPath.item] = fetchOperation
        

        let cachePhoto = BlockOperation {
            if let image = fetchOperation.imageData {
                
                self.largePhotoCache.cache(value: image, for: indexPath.item)
            }
        }
        
        let setImageOperation = BlockOperation {
            if let image = fetchOperation.imageData {
                DispatchQueue.main.async {
                    vc.userImage.image = image
                }
            }
        }
        
        cachePhoto.addDependency(fetchOperation)
        setImageOperation.addDependency(fetchOperation)
        
        largePhotoFetchQueue.addOperations([fetchOperation, cachePhoto, setImageOperation], waitUntilFinished: false)
    }
    
    
}
