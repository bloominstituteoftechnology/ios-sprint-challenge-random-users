//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by John Pitts on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addUsersButtonPressed(_ sender: Any) {
        
        // Begin fetching users by calling GET method to download from api
        userController.getUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "banged" bc if cell not there whole program worthless anyhow
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        cell.cellNameLabel.text = userController.users[indexPath.row].name
        
        // Call a func to manage clever downloading/handling of Users PICTURE DATA into cells
        loadImage(forCell: cell, forItemAt: indexPath)
//        let photoReferences = userController.users
//        // CheatCode
//        if let data = try? Data(contentsOf: photoReferences[indexPath.row].image) {
//            cell.cellImage.image = UIImage(data: data)
//        } else { print("error, no image") }
        
        
        return cell
    }
    
    
    // func will need to check cache first, then user proper cancels and order of Operations to manage fast queues/threads
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let photoReferences = userController.users
        

        let photoReference = photoReferences[indexPath.row]
        
        // If  image already in cache U get it for free!
        
        // key = imageReference (a user, but i need imagepath instead)
        if let cachedImageData = cache.value(for: indexPath.row),     // shouldn't it just be the index?
            let image = UIImage(data: cachedImageData) {
            cell.imageView?.image = image
            return
        }
        
        // Start an operation to fetch image data
        let fetchOp = FetchPhotoOperation(photoReference: photoReference)
        
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, for: indexPath.row)
            }
        }
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: indexPath.row) }
            
            if let currentIndexPath = self.tableView?.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("Got image for now-reused cell")
                return // Cell has been reused
            }
            
            if let data = fetchOp.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[indexPath.row] = fetchOp
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "UserDetail" {
            guard let destinationVC = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let user = userController.users[indexPath.row]
            destinationVC.userController = userController
            destinationVC.user = user
        }

    }
    
    // MARK: PROPERTIES
    
    
    private let cache = Cache<Int, Data>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [Int : Operation]()
    
    var userController = UserController()
    
    private var photoReferences = [User]() {
        didSet {
            DispatchQueue.main.async { self.tableView?.reloadData() }
        }
    }
}
