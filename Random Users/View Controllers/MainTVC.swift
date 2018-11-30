//
//  MainTVC.swift
//  Random Users
//
//  Created by Nikita Thomas on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController {
    
    let networking = UserNetworking()
    
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var cache: Cache<String, UIImage> = Cache()
    var userFetchQueue = OperationQueue()
    var fetchRequests: [String: FetchPhotoOperation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.fetchUsers { (users, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.users = users
        }
    }
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let user = users?[indexPath.row], let phoneNumber = user.phoneNumber else { return }
        
        if let phoneNumber = user.phoneNumber, let cacheImage = cache.value(for: phoneNumber) {
            cell.imageView?.image = cacheImage
        } else {
            
            let op1 = FetchPhotoOperation(user: user, imageType: .thumbnail)
            
            let op2 = BlockOperation {
                guard let image = op1.image else { return }
                self.cache.cache(value: image, for: phoneNumber)
            }
            
            op2.addDependency(op1)
            
            let op3 = BlockOperation {
                guard let image = op1.image else { return }
                if indexPath == self.tableView.indexPath(for: cell) {
                    cell.imageView?.image = image
                }
            }
            op3.addDependency(op1)
            
            userFetchQueue.addOperation(op1)
            userFetchQueue.addOperation(op2)
            OperationQueue.main.addOperation(op3)
            fetchRequests[phoneNumber] = op1
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user = users?[indexPath.row]
        cell.textLabel?.text = user?.name
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row], let phoneNumber = user.phoneNumber else { return }
        fetchRequests[phoneNumber]?.cancel()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users?[indexPath.row]
            destinationVC.user = user
            destinationVC.title = user?.name
        }
    }
}
