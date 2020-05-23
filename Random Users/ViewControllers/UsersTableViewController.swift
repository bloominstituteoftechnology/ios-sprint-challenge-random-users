//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Thomas Dye on 5/23/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
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

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        guard let userCell = cell as? UserTableViewCell else { return cell }
        
        let user = userController.users[indexPath.row]
        userCell.nameLabel?.text = user.name
        
        loadImage(forCell: userCell, forItemAt: indexPath)

        // Configure the cell...

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    //MARK: Fuctions:
    
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
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
        //print(fetchPhotoOperations[indexPath.row]!.state)
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let vc = segue.destination as? UserDetailViewController,
                let indexpath = tableView.indexPathForSelectedRow    else { return }
            
            let userIndex = indexpath.row
            let user = userController.users[userIndex]
            vc.user = user
            vc.userController = userController
            vc.userIndex = userIndex
        }
    }
}
