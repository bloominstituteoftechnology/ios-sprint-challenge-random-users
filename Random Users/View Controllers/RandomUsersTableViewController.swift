//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    var userController = UserController()
    private let cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [String : Operation]()
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        userController.fetchUsers() { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = userController.users[indexPath.row]
                
        // Check if there is cached data
        if let cachedData = cache.value(key: user.picture.thumbnail),
            let image = UIImage(data: cachedData) {
            cell.thumbnail.image = image
            return
        }
        
        // Start fetch operations
        let fetchOp = FetchPhotoOperation(photoReference: user.picture)
        
        // Save data in the cache with key
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, key: user.picture.thumbnail)
            }
        }
        
        // Put the image in the row
        let completitionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: user.picture.thumbnail) }
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath { // reuse cell
                return
            }
            if let data = fetchOp.imageData {
                cell.thumbnail.image = UIImage(data: data)
            }
        }
        
        // fetchOp must finish first
        cacheOp.addDependency(fetchOp)
        completitionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completitionOp)
        
        operations[user.picture.thumbnail] = fetchOp
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        operations[user.picture.thumbnail]?.cancel()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? RandomUserTableViewCell else { return UITableViewCell() }

        let user = userController.users[indexPath.row]
        cell.fullName.text = "\(user.name.first) \(user.name.last)"
        
        if let url = URL(string: user.picture.thumbnail) {
            if let data = try? Data(contentsOf: url) {
                cell.thumbnail.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromCellSegue" {
            guard let detailVC = segue.destination as? RandomUserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            detailVC.user = user
            detailVC.userController = userController
        }
    }
}
