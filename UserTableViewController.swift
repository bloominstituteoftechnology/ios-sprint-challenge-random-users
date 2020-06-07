//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Nonye on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    let userController = UserController()
    var fetchPhotoOperations: [Int: FetchPhotoOperation] = [:]
    private let photoFetchQueue = OperationQueue()
    var thumbnailCache = Cache<Int, Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoFetchQueue.name = "com.RandomeUsers.PhotFectchQueue"
        userController.fetchUsers { (error) in
            if let error = error {
                print("Error fetching user: \(error)")
            }
            
            DispatchQueue.main.async {
                print(self.userController.users.count)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
        guard let peopleCell = cell as? PeopleCell else { return cell }
        
        let user = userController.users[indexPath.row]
        peopleCell.userLabel?.text = user.name
        
        loadImage(forCell: peopleCell, forItemAt: indexPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    private func loadImage(forCell cell: PeopleCell, forItemAt indexPath: IndexPath) {
        if let imageData = thumbnailCache.value(for: indexPath.row) {
            cell.userImageView?.image = UIImage(data: imageData)
        }
        
        let user = userController.users[indexPath.row]
        let fetchPhotoOperation = FetchPhotoOperation(userImageUrl: user.picture[0])
        
        let storeToCache = BlockOperation {
            if let imageData = fetchPhotoOperation.imageData {
                self.thumbnailCache.cache(value: imageData, for: indexPath.row)
            }
        }
        
        let cellReuseCheck = BlockOperation {
            if self.tableView.indexPath(for: cell) == indexPath {
                guard let imageData = fetchPhotoOperation.imageData else { return }
                cell.userImageView.image = UIImage(data: imageData)
            }
        }
        
        storeToCache.addDependency(fetchPhotoOperation)
        cellReuseCheck.addDependency(fetchPhotoOperation)
        
        photoFetchQueue.addOperations([fetchPhotoOperation, storeToCache], waitUntilFinished: false)
        OperationQueue.main.addOperation(cellReuseCheck)
        fetchPhotoOperations[indexPath.row] = fetchPhotoOperation
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let userVC = segue.destination as? PeopleDetailViewController,
                let indexpath = tableView.indexPathForSelectedRow    else { return }
            
            let userIndex = indexpath.row
            let user = userController.users[userIndex]
            userVC.user = user
            userVC.userController = userController
            userVC.userIndex = userIndex
        }
    }
}
