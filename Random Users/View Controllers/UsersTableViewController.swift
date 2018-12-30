//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var fetchOperations: [String: FetchPhotoOperation] = [:]
    private var photoFetchQueue = OperationQueue()
    private var cache = Cache<String, Data>()
    private var userFetchQueue = OperationQueue()
    let fetchURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.title = "\(self.users.count) Users"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchUsersOperation = FetchUsersOperation(url: fetchURL)
        userFetchQueue.addOperation(fetchUsersOperation)
        userFetchQueue.waitUntilAllOperationsAreFinished()
        
        guard let users = fetchUsersOperation.users else { return }
        self.users = users
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        loadImage(of: user, for: cell)
        cell.textLabel?.text = user.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let fetchOperaiton = fetchOperations[user.name] {
            fetchOperaiton.cancel()
        }
    }
    
    // MARK: - Private Methods
    
    // Load images from cache or api
    private func loadImage(of user: User, for cell: UITableViewCell) {
        
        if let imageData = cache.value(for: user.name) {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
            return
        }
        
        let fetchPhotoOperation = FetchPhotoOperation(user: user)
        
        let storeDataInCacheOperation = BlockOperation {
            guard let data = fetchPhotoOperation.imageData else { return }
            self.cache.cache(value: data, for: user.name)
        }
        
        let updateCellImageOperation = BlockOperation {
            guard let imageData = fetchPhotoOperation.imageData else { return }
            let image = UIImage(data: imageData)
            
            if self.tableView.visibleCells.contains(cell) {
                cell.imageView?.image = image
                self.tableView.reloadData()
            }
        }
        
        storeDataInCacheOperation.addDependency(fetchPhotoOperation)
        updateCellImageOperation.addDependency(fetchPhotoOperation)
        
        photoFetchQueue.addOperation(fetchPhotoOperation)
        photoFetchQueue.addOperation(storeDataInCacheOperation)
        
        OperationQueue.main.addOperation(updateCellImageOperation)
        
        fetchOperations[user.name] = fetchPhotoOperation
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let destinationVC = segue.destination as? UsersDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            destinationVC.user = user
        }
    }
    
    // Load 1000 more users
    @IBAction func addUsersButton(_ sender: Any) {
        let fetchUsersOperation = FetchUsersOperation(url: fetchURL)
        userFetchQueue.addOperation(fetchUsersOperation)
        userFetchQueue.waitUntilAllOperationsAreFinished()
        
        guard let newUsers = fetchUsersOperation.users else { return }
        users.append(contentsOf: newUsers)
    }
}
