//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Samantha Gatt on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userClient.fetchUsers { (users, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.users = users
        }
    }
    
    // MARK: - Properties
    
    let userClient = UserClient()
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var thumbnailCache: Cache<String, UIImage> = Cache()
    var userFetchQueue = OperationQueue()
    var fetchRequests: [String: FetchImageOperation] = [:]
    
    // MARK: - Actions
    
    @IBAction func loadMoreUsers(_ sender: Any) {
        
    }
    
    
    // MARK: - Private functions
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let user = users?[indexPath.row], let phoneNumber = user.phoneNumber else { return }
        
        if let phoneNumber = user.phoneNumber, let image = thumbnailCache[phoneNumber] {
            cell.imageView?.image = image
            
        } else {
            
            let op1 = FetchImageOperation(user: user, imageType: .thumbnail)
            
            let op2 = BlockOperation {
                guard let image = op1.image else { return }
                self.thumbnailCache.cache(value: image, for: phoneNumber)
            }
            op2.addDependency(op1)
            
            let op3 = BlockOperation {
                guard let image = op1.image else { return }
                if indexPath == self.tableView.indexPath(for: cell) {
                    cell.imageView?.image = image
                }
            }
            op3.addDependency(op1)
            
            userFetchQueue.addOperations([op1, op2], waitUntilFinished: false)
            OperationQueue.main.addOperation(op3)
            fetchRequests[phoneNumber] = op1
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        let user = users?[indexPath.row]
        cell.textLabel?.text = user?.name
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row], let phoneNumber = user.phoneNumber else { return }
        let op = fetchRequests[phoneNumber]
        op?.cancel()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            let destinationVC = segue.destination as! UserDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.user = users?[indexPath.row]
        }
    }
}
