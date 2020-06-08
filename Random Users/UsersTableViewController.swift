//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    
    //MARK: - Properties
    
    var networkClient = Client()
    private let cache = Cache<Int,Data>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [Int: Operation]()
    
    var usersArray: [User] = [] {
        didSet {
            tableView.reloadData()
            print("\(usersArray.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkClient.loadUsers { (result) in
            
            if let users = try? result.get() {
                DispatchQueue.main.async {
                    self.usersArray = users
                }
            }
        }
    }
    
  
    
    @IBAction func addUsersButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCustomCell", for: indexPath) as? UserCustomTableViewCell ?? UserCustomTableViewCell()
        
        let user = usersArray[indexPath.row]
        
        cell.userNameInCell.text = "\(user.title). \(user.first) \(user.last)"
        //cell.userImageInCell.image = UIImage(data: user.thumbnail)
        
        loadImage(forCell: cell, forCellAt: indexPath)
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photoReference = usersArray[indexPath.row]
        guard let id = Int(photoReference.id) else { return }
        operations[id]?.cancel()
        print("photo was cancelled")
    }
    
    private func loadImage(forCell cell: UserCustomTableViewCell, forCellAt indexPath: IndexPath) {
        
        let photoReference = usersArray[indexPath.row]
        
        guard let id = Int(photoReference.id) else { return }
        
        if let cachedData = cache.value(key: id),
            let image = UIImage(data: cachedData) {
            
            cell.userImageInCell.image = image
            return
            
        }
        
        let fetchOp = FetchPhotoOperation(photoReference: photoReference, imageType: .thumbnail)
        
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, key: id)
            }
        }
        
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: id) }
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("Got image for reused cell")
                return
            }
            if let data = fetchOp.imageData {
                cell.userImageInCell.image = UIImage(data: data)
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[id] = fetchOp
        
    }
    
//        func loadLargeImage(forUser user: User) {
//
//            guard let id = Int(user.id) else { return }
//
//            if let cachedData = cache.value(key: id),
//                let image = UIImage(data: cachedData) {
//
//                userImage.image = image
//                return
//
//            } else {
//                let fetchOp = FetchLargePhoto(photoReference: user)
//
//                    let completionOp = BlockOperation {
//                        guard user == self.user else { return }
//
//                        guard let data = fetchOp.imageData else { return }
//
//                        self.userImage.image = UIImage(data: data)
//
//                        }
//
//                    completionOp.addDependency(fetchOp)
//
//                    OperationQueue.main.addOperations([fetchOp, completionOp], waitUntilFinished: false)
//            }
//        }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserDetailSegue" {
            
            guard let detailVC = segue.destination as? UserDetailViewController else { return }
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                detailVC.networkClient = networkClient
                detailVC.user = usersArray[indexPath.row]
            }
        }
    }
}
