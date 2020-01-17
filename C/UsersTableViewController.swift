//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    let userController = UserController()
    var getOperation: [String : FetchPicture] = [:]
    let photoQueue = OperationQueue()
    let pictureCache = PictureCache<String, Data>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell
        
        let user = userController.users[indexPath.row]
        cell.user = user
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let name = (user.name["first"]!) + " " + (user.name["last"]!)
        
        if let getOperation = getOperation[name] {
            getOperation.cancel()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        userController.addUsers = true
        userController.fetchUsers { (error) in
            if let error = error {
                print("Error fetching users: \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Functions
    
    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        
        let photoReference = userController.users[indexPath.row]
        let name: String = (photoReference.name["first"]!) + " " + (photoReference.name["last"]!)
        
        if let cacheImage = pictureCache.thumbnailValue(for: name) {
            cell.userImage.image = UIImage(data: cacheImage)
        } else {
            let getPhotoOperation = FetchPicture(user: photoReference)
            getOperation[name] = getPhotoOperation
            
            let storeDataOp = BlockOperation {
                guard let data = getPhotoOperation.pictureData else { return }
                self.pictureCache.cacheThumbnails(value: data, for: name)
            }
            
            let reuseOp = BlockOperation {
                guard let currentIndex = self.tableView.indexPath(for: cell), let data = getPhotoOperation.pictureData else { return }
                
                if currentIndex == indexPath {
                    cell.userImage.image = UIImage(data: data)
                    
                } else {
                    return
                }
            }
            
            storeDataOp.addDependency(getPhotoOperation)
            reuseOp.addDependency(getPhotoOperation)
            
            photoQueue.addOperation(getPhotoOperation)
            photoQueue.addOperation(storeDataOp)
            OperationQueue.main.addOperation(reuseOp)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserCellSegue" {
            guard let destinationVC = segue.destination as? UsersDetailedViewController,
                let cell = sender as? UsersTableViewCell else { return }
            destinationVC.userController = userController
            destinationVC.user = cell.user
        }
    }
    
    
}
