//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Daniela Parra on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Lifecycle Methods
    
    //Creates a fetch request to fill the table view with users.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchUsersOp = FetchUsersOperation(url: fetchURL)
        userFetchQueue.addOperation(fetchUsersOp)
        userFetchQueue.waitUntilAllOperationsAreFinished()
        
        //If users returned, sets the users array to just fetched users.
        guard let users = fetchUsersOp.users else { return}
        self.users = users
//        print("\(users.count)")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    //Sets up cells for reuse with content from model object.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        //Sets up cell with user's name and thumbnail image
        let user = users[indexPath.row]
        loadImage(of: user, for: cell)
        cell.textLabel?.text = user.name
        
//        print("Updating cell at \(indexPath)")
        return cell
    }
    
    //Cancels fetch operation for cells out of view.
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        //If fetch operation exists, it cancels it.
        if let fetchOperation = fetchOperations[user.name] {
            fetchOperation.cancel()
            print("Canceling operation at \(indexPath)")
        }
    }
  
    // MARK: - Private Methods
    
    //Loads image for a given cell.
    private func loadImage(of user: User, for cell: UITableViewCell) {
        if let imageData = cache.value(for: user.name) {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
            return
        }
        
        let fetchPhotoOp = FetchPhotoOperation(user: user)
        
        let storeDataInCacheOp = BlockOperation {
            guard let data = fetchPhotoOp.imageData else { return }
            self.cache.cache(value: data, for: user.name)
        }
        
        let updateCellImageOp = BlockOperation {
            guard let imageData = fetchPhotoOp.imageData else { return }
            let image = UIImage(data: imageData)
            if self.tableView.visibleCells.contains(cell) {
                cell.imageView?.image = image
                self.tableView.reloadData()
            }
        }
        
        storeDataInCacheOp.addDependency(fetchPhotoOp)
        updateCellImageOp.addDependency(fetchPhotoOp)
        
        photoFetchQueue.addOperation(fetchPhotoOp)
        photoFetchQueue.addOperation(storeDataInCacheOp)
        OperationQueue.main.addOperation(updateCellImageOp)
        
        fetchOperations[user.name] = fetchPhotoOp
    }
     
     @IBAction func addUsers(_ sender: Any) {
        let fetchUsersOp = FetchUsersOperation(url: fetchURL)
        userFetchQueue.addOperation(fetchUsersOp)
        userFetchQueue.waitUntilAllOperationsAreFinished()
        guard let newUsers = fetchUsersOp.users else { return}
        
        users.append(contentsOf: newUsers)
        print("\(users.count)")
        
    }
 
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUser" {
            guard let destinationVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            destinationVC.user = user
        }
    }
    
    //Not sure.
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var fetchOperations: [String: FetchPhotoOperation] = [:]
    private var photoFetchQueue = OperationQueue()
    private var cache = Cache<String, Data>()
    
    private var userFetchQueue = OperationQueue()
    let fetchURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
}
