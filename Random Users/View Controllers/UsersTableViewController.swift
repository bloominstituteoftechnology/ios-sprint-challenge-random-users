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
        
        //Checks to see if image data is already cached.
        if let imageData = cache.value(for: user.name) {
            //If it is, it sets the image for the cell.
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
            return
        }
        
        //Create fetch photo operations with user.
        let fetchPhotoOp = FetchPhotoOperation(user: user)
        
        //Creates bloack operation to store image data in cache.
        let storeDataInCacheOp = BlockOperation {
            guard let data = fetchPhotoOp.imageData else { return }
            self.cache.cache(value: data, for: user.name)
        }
        
        //Updates cell with image from image data.
        let updateCellImageOp = BlockOperation {
            guard let imageData = fetchPhotoOp.imageData else { return }
            let image = UIImage(data: imageData)
            if self.tableView.visibleCells.contains(cell) {
                cell.imageView?.image = image
                self.tableView.reloadData()
            }
        }
        
        //Both store and update operations are dependant on the fetch photo operation.
        storeDataInCacheOp.addDependency(fetchPhotoOp)
        updateCellImageOp.addDependency(fetchPhotoOp)
        
        //Add fetch photo and store data operations on background queue.
        photoFetchQueue.addOperation(fetchPhotoOp)
        photoFetchQueue.addOperation(storeDataInCacheOp)
       
        //Add update image operation on main queue.
        OperationQueue.main.addOperation(updateCellImageOp)
        
        //Add fetch photo operation to array in case you need to cancel it.
        fetchOperations[user.name] = fetchPhotoOp
    }
    
    //Adds 1000 random users to the table view.
     @IBAction func addUsers(_ sender: Any) {
        
        //Creates another fetch users operation.
        let fetchUsersOp = FetchUsersOperation(url: fetchURL)
        userFetchQueue.addOperation(fetchUsersOp)
        userFetchQueue.waitUntilAllOperationsAreFinished()
        
        //Adds new users to existing array of users.
        guard let newUsers = fetchUsersOp.users else { return}
        users.append(contentsOf: newUsers)
//        print("\(users.count)")
        
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Pass selected user to the user detail VC.
        if segue.identifier == "ShowUser" {
            guard let destinationVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            destinationVC.user = user
        }
    }
    
    
    // MARK: - Properties

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
