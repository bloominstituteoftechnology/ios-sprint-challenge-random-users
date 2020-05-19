//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Breena Greek on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    // MARK: - Propertires
    
    private let fetchQueue = OperationQueue()
    private var imageFetchOperations = [User : Operation]()

    // MARK: - IBOutlet
    
    @IBAction func addUsers(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let fetchOperation = UserOperations(numberOfUsers: 1000)
        let update = BlockOperation {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let users = fetchOperation.results else { return }
            UserController.shared.addUsers(users)
            self.tableView.reloadData()
        }
        update.addDependency(fetchOperation)
        
        fetchQueue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(update)
    }

    // MARK: TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.users.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")
               else { fatalError("Inconstructable cell") }
        
           
            let user = UserController.shared.users[indexPath.row]
            
            cell.textLabel?.text = "\(user.name.title). \(user.name.first) \(user.name.last)"
            cell.imageView?.image = UIImage(named: "Lambda_Logo_Full")!
            cell.imageView?.contentMode = .scaleAspectFit
            if let cachedImage = Cache.cache[thumbnail: user] {
                cell.imageView?.image = cachedImage
            } else {
                
                let imageFetch = ImageOperations(user: user, imageType: .thumbnail)
                imageFetch.completionBlock = { [weak imageFetchOp = imageFetch] in
                    Cache.cache[thumbnail: user] = imageFetchOp?.result
                }
                let updateUIOp = BlockOperation {
                    defer { self.imageFetchOperations.removeValue(forKey: user) }
                    
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                        currentIndexPath != indexPath {
                        return
                    }
                    
                    cell.imageView?.image = imageFetch.result
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                updateUIOp.addDependency(imageFetch)
                fetchQueue.addOperation(imageFetch)
                OperationQueue.main.addOperation(updateUIOp)
            }
            
            return cell
        }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow
                else { return }
            let detailVC = segue.destination as! UserDetailViewController
            
            detailVC.user = UserController.shared.users[indexPath.row]
        }
    }

}
