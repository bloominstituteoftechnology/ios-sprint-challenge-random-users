//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: - Properties and IBOutlets -
    
    var imageOpsDictionary: [ Int : BlockOperation ] = [:]
    
    var userController = UserController()
    var cache = Cache<Int, UIImage>()
    
    var imageFetchingQueue: OperationQueue {
        
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
        
    }
    
    //MARK: - Methods and IBActions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.getUser { (result) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Table view data source & Methods -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        let user = userController.users[indexPath.row]
        let imageURL = user.picture.thumbnail
        
        let fetchImageOperation = BlockOperation {
            
            cell.user = user
            
            self.userController.getUserImage(imageURLString: imageURL) { (result) in
                DispatchQueue.main.async {
                    do {
                        let fetchedImage = try result.get()
                        self.cache.cache(value: fetchedImage, for: indexPath.row)
                        cell.userImageView.image = fetchedImage
                        cell.setNeedsLayout()
                    } catch {
                        NSLog("Could not acquire the user's thumbnail image: \(error)")
                        return
                    }
                }
                
            }
        }
        
        cell.user = user
        imageOpsDictionary[indexPath.row] = fetchImageOperation
        
        if let cachedImage = cache.value(for: indexPath.row) {
            cell.userImageView.image = cachedImage
        } else {
            imageFetchingQueue.addOperation(fetchImageOperation)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let opToCancel = imageOpsDictionary[indexPath.row]
        opToCancel?.cancel()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UserDetailSegue" {
            
            guard let detailVC = segue.destination as? UserDetailViewController else { return }
            let selectedUser = userController.users[tableView.indexPathForSelectedRow!.row]
            detailVC.user = selectedUser
            userController.getUserImage(imageURLString: selectedUser.picture.large) { (result) in
                
                DispatchQueue.main.async {
                    
                    do {
                        detailVC.imageView.image = try result.get()
                    } catch {
                        NSLog("Could not acquire meduim size image for the detail view: \(error)")
                        return
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
} //End of class
