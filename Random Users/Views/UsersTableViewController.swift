//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by denis cedeno on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let userController = UserController()
    private let fetchQueue = OperationQueue()
    private var fetchOpertions: [String : FetchPhotoOperation] = [:]
    var cache = Cache<String, Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        cell.textLabel?.text = userController.users[indexPath.row].name
        loadImage(for: cell, indexPath: indexPath)
        return cell
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? UsersDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        detailVC.user = userController.users[indexPath.row]
        detailVC.fetchQueue = fetchQueue
    }

    func loadImage(for cell: UITableViewCell, indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let photoFetchOperation = FetchPhotoOperation(userPhotoRefernce: user)
        
        if let imageData = cache.value(for: user.email) {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
        }
        
        let cacheOperation = BlockOperation {
            if let image = photoFetchOperation.imageData {
                self.cache.cache(value: image, for: user.email)
            }
        }
        
        let cellReuseOperation = BlockOperation {
            if self.tableView.indexPath(for: cell) != indexPath {
                return
            } else {
                guard let data = photoFetchOperation.imageData else { return }
                let image = UIImage(data: data)
                cell.imageView?.image = image
            }
        }
        
        cacheOperation.addDependency(photoFetchOperation)
        cellReuseOperation.addDependency(cacheOperation)
        fetchQueue.addOperations([photoFetchOperation, cacheOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(cellReuseOperation)
        fetchOpertions[userController.users[indexPath.row].name] = photoFetchOperation
        
    }
}
