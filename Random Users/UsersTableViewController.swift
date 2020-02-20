//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

// Cell
// DetailSegue
import UIKit

class UsersTableViewController: UITableViewController {

    // MARK: - Properties
    
    private var operations = [String : FetchUserOperation]()
    private var cache = Cache<String, UIImage>()
    private var photoFetchQueue = OperationQueue()
    let userController = UserController()
    
    private var photoReferences = [User]() {
        didSet {
            DispatchQueue.main.async { self.tableView?.reloadData() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers { (error) in
            if let error = error {
                print("well shit: \(error)")
            } else {
                DispatchQueue.main.async {
                    print("success")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData() // ? could mess stuff up
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user = userController.users[indexPath.row]
        cell.textLabel?.text = user.name
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = userController.users[indexPath.row]
        
        // Check for image in cache
        if let cachedImage = cache.value(for: user.email) {
            cell.imageView?.image = cachedImage
            return
        }
        
        else {
            
            // Start an operation to fetch image data
            let fetchOp = FetchUserOperation(user: user)
            
            let cacheOp = BlockOperation {
                if let image = fetchOp.image {
                    self.cache.cache(value: image, for: user.email)
                }
            }
            
            let completionOp = BlockOperation {
                defer { self.operations.removeValue(forKey: user.email) }
                
                if let currentIndexPath = self.tableView?.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    print("Got image for now-reused cell")
                    return // Cell has been reused
                }
                
                if let image = fetchOp.image {
                    cell.imageView?.image = image
                }
            }
            
            cacheOp.addDependency(fetchOp)
            completionOp.addDependency(fetchOp)
            
            photoFetchQueue.addOperation(fetchOp)
            photoFetchQueue.addOperation(cacheOp)
            OperationQueue.main.addOperation(completionOp)
            
            operations[user.email] = fetchOp
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            guard let detailVC = segue.destination as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let user = userController.users[indexPath.row]
            detailVC.userController = userController
            detailVC.user = user
        }
    }

}
