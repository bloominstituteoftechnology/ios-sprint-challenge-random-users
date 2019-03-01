//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Julian A. Fordyce on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func add(_ sender: Any) {
        userController.fetchRandomUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let randomUser = userController.users[indexPath.row]
        cell.textLabel?.text = randomUser.name
        load(for: cell, forItemAt: indexPath)
        return cell
    }


    private func load(for cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let randomUser = userController.users[indexPath.row]
        
        if let image = cache.value(for: randomUser.phone) {
            cell.imageView?.image = image
            } else {
            let fetchPhotoOp = FetchPhotoOp(user: randomUser)
            
            let cacheOperation = BlockOperation {
                guard let image = fetchPhotoOp.image else { return }
                self.cache.cache(value: image, for: randomUser.phone)
            }
            
            
            let reuseCellOperation = BlockOperation {
                guard let image = fetchPhotoOp.image else { return }
                
                if self.tableView.indexPath(for: cell) == indexPath {
                    cell.imageView?.image = image
                    self.tableView.reloadData()
                }
            }
            
            cacheOperation.addDependency(fetchPhotoOp)
            reuseCellOperation.addDependency(fetchPhotoOp)
            
            fetchPhotoQueue.addOperations([fetchPhotoOp, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(reuseCellOperation)
            
            fetchedOperations[randomUser.phone] = fetchPhotoOp
        }
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellDetail" {
            guard let dvc = segue.destination as? UserDetailViewController,
                let tappedRow = tableView.indexPathForSelectedRow else { return }
            
            let randomUser = userController.users[tappedRow.row]
            
            dvc.userController = userController
            dvc.user = randomUser
        }
    }
  

    // MARK: - Properties
    
    let userController = UserController()
    private var cache: Cache<String, UIImage> = Cache()
    private let fetchPhotoQueue = OperationQueue()
    private var fetchedOperations: [String : FetchPhotoOp] = [:]
    
}
