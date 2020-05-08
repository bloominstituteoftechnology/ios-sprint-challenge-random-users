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
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUserCell", for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        // Configure the cell...
        cell.user = users[indexPath.item]
        return cell
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        
        cell.cellIndexPath = indexPath
        
        let cacheIndex = cell.cellIndexPath
        let imageThumbNail = users[cacheIndex.item].picture.thumbnail
        
        if let cache = cache.value(for: cacheIndex.item) {
            cell.imageView.image = UIImage(data: cache)
            return
        } else {
            let fetchedPhoto = PhotoFetchOperation(photoReference: photoReference)
            
            let cachePhotoData = BlockOperation {
                if let imageData = fetchedPhoto.imageData {
                    self.cache.cache(value: imageData, for: photoReference.id)
                }
            }
            
            let cellPhotoData = BlockOperation {
                guard let imageData = fetchedPhoto.imageData else { return }
                DispatchQueue.main.async {
                    if self.collectionView.indexPath(for: cell) == indexPath {
                        cell.imageView.image = UIImage(data: imageData)
                    } else {
                        return
                    }
                }
            }
            
            cachePhotoData.addDependency(fetchedPhoto)
            cellPhotoData.addDependency(fetchedPhoto)
            
            photoFetchQueue.addOperations([cachePhotoData, cellPhotoData, fetchedPhoto], waitUntilFinished: false)
            photoDictionary[photoReference.id] = fetchedPhoto
            // TODO: Implement image loading here
        }
    }
    
    
}
