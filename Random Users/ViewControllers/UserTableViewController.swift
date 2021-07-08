//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Jerrick Warren on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchUsersOp = FetchUserOp(url: fetchURL)
        userFetchQueue.addOperation(fetchUsersOp)
        userFetchQueue.waitUntilAllOperationsAreFinished()
        guard let users = fetchUsersOp.users else { return}
        self.users = users
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let fetchUsersOp = FetchUserOp(url: fetchURL)
//        userFetchQueue.addOperation(fetchUsersOp)
//        userFetchQueue.waitUntilAllOperationsAreFinished()
//        guard let users = fetchUsersOp.users else { return}
//        self.users = users
//
//
//    }
    
    // MARK: - Properties
    
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // var fetchOperations: [FetchPhotoOp] = [:] must be literal
    var fetchOperations: [String: FetchPhotoOp] = [:]
    
    // set up queues for user and photo
    private var userFetchQueue = OperationQueue()
    private var photoFetchQueue = OperationQueue()
    
    // set up cache
    private var cache = Cache<String, Data>()
    
    let fetchURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=200")!
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    //Sets up cells for reuse with content from model object.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.layer.borderWidth = 0.5
        
        loadUserPhoto(of: user, for: cell)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        if let fetchOperation = fetchOperations[user.name] {
            fetchOperation.cancel() // cancels out or view cells
        }
    }
    
    // MARK: - Private Methods
    
    private func loadUserPhoto(of user: User, for cell: UITableViewCell) {
        
        let fetchPhotoOp = FetchPhotoOp(user: user)
        
        //guard let imageData = cache.value(for: user.name) else { return }
        if let imageData = cache.value(for: user.name) {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
            return
        }
        
        // cache blockOp
        let dataCacheOp = BlockOperation {
            guard let data = fetchPhotoOp.imageData else { return }
            self.cache.cache(value: data, for: user.name)
        }
        
        // update photo blockOp
        let updateUserPhotoOp = BlockOperation {
            guard let imageData = fetchPhotoOp.imageData else { return }
            let image = UIImage(data: imageData)
            
//            if let currentIndexPath = self.tableView.indexPath(for: cell),
//                currentIndexPath != indexPath {
//                print("Got image for now-reused cell")
//                return // Cell has been reused
//            }
//
//            if self.tableView.visibleCells.contains(cell) {
//                cell.imageView?.image = image
//                self.tableView.reloadData()
//            }
        }
        
        // add dependancies, then opperations
        dataCacheOp.addDependency(fetchPhotoOp)
        updateUserPhotoOp.addDependency(fetchPhotoOp)
        
        photoFetchQueue.addOperation(fetchPhotoOp)
        photoFetchQueue.addOperation(dataCacheOp)
        
        
        //imageOp on main queue.
        OperationQueue.main.addOperation(updateUserPhotoOp)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let destinationVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            destinationVC.user = user
        }
    }
    
    // Mark: - Outlets
    @IBAction func addUsers(_ sender: Any) {
        
        let fetchUsersOp = FetchUserOp(url: fetchURL)
        userFetchQueue.addOperation(fetchUsersOp)
        userFetchQueue.waitUntilAllOperationsAreFinished()
        
        guard let addedUsers = fetchUsersOp.users else { return}
        users.append(contentsOf: addedUsers)
        
    }
    
}
