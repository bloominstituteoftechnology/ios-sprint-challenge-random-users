//
//  RandomUsersListTableViewController.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersListTableViewController: UITableViewController {

    //this is to store thumbnail images for person. (Person is the key and the value is the image)
    var cache: Cache<String, UIImage> = Cache()
    
    //this will be used to put the operations on the right queue
    var photoFetchQueue = OperationQueue()
    
    //this dictionary will be used to cancel operation calls
    var storedFetchOperations: [ String : FetchPhotoOperation ] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.fetchUsers { (error) in
            if let error = error {
                print("error ontable view: \(error)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.backgroundColor = .blue
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserController.shared.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RandomUserTableViewCell

        // Configure the cell...
        loadImage(forCell: cell, forItemAt: indexPath)
        
        let userToPass = UserController.shared.users[indexPath.row]
        cell.user = userToPass
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = UserController.shared.users[indexPath.row]
        storedFetchOperations[user.fullName]?.cancel()
    }
    
    //call this in cellForAtRow
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath){
        //get user
        let user = UserController.shared.users[indexPath.row]
        
        //check to see if the cache contains data from the network, if it does then set the cell's properties and return
        if let imageInCache = cache.returnCachedValue(forKey: user.fullName){
            //user is in cache so we can set the cell's properties
            cell.imageView?.image = imageInCache
        } else {
            //image not in cache, fetch user, store user in cache, check to see if cell has been reused
            let fetchPhotoOperation = FetchPhotoOperation(user: user, imageURL: user.thumbnail) //this makes the network call for the user's thumbnail
            
            //cacheOperation
            let cacheOperation = BlockOperation {
                guard let data = fetchPhotoOperation.imageData, let image = UIImage(data: data) else { print("Error making image from data in cacheOperation"); return }
                self.cache.cacheAdd(value: image, forKey: user.fullName)
            }
            
            //this operation should check if the cell has been reused and if not set its image view image
            let reuseOperation = BlockOperation {
                guard let data = fetchPhotoOperation.imageData, let image = UIImage(data: data) else { print("Error making image from data in reuseOperation"); return }
                
                //this is checking to see if the cells are visible (on the screen)
                if self.tableView.indexPath(for: cell) == indexPath {
                    self.tableView.reloadData()
                } else {
                    //if cells are not visible/on the screen, set the image before they appear
                    cell.imageView?.image = image
                }
            }
            //make the cache and reuse dependent on fetch //this will help avoid race conditions by stating that these two cannot execute until after we've fetchedPhotos
            cacheOperation.addDependency(fetchPhotoOperation)
            reuseOperation.addDependency(fetchPhotoOperation)
            
            //add each operation to the appropriate queue
            photoFetchQueue.addOperations([fetchPhotoOperation, cacheOperation], waitUntilFinished: true)
            
            //because this is actually setting/interacting with uikit we have to do this on the main queue
            OperationQueue.main.addOperation(reuseOperation)
            
            //when you finish creating and starting the operations for a cell, add the fetch operation to your dictionary. This way you can retrieve it later to cancel if need be
            storedFetchOperations[user.fullName] = fetchPhotoOperation
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CellSegue" {
            guard let toVC = segue.destination as? DetailUserViewController, let indexpath = tableView.indexPathForSelectedRow else { print("error in table view segue"); return }
            let userToPass = UserController.shared.users[indexpath.row]
            toVC.user = userToPass
//            toVC.cache = cache  //passing this to the detail will make the picture really blurry for some reason
        }
    }
}
