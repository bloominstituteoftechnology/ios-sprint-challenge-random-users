//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK:- Properties
    
    private let userController = UserController()
    private let cache = Cache<String,Data>()
    private var photoFetchQueue = OperationQueue()
    private var fetchOperations = [String:Operation]()
    let queue = DispatchQueue(label: "CancelOperationQueue")
    private enum ID :String {
        case reuseCellID = "UserCell"
        case segueID = "CellSegueToDetail"
    }
    
    
    
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        userController.fetchUsers { (users, error) in
            //
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
       
    }
//MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return userController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID.reuseCellID.rawValue, for: indexPath)
        
        let currentUser = userController.users[indexPath.row]
        cell.textLabel?.text = currentUser.name
      
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let contact =  userController.users[indexPath.row]
//        fetchOperations[contact.name]?.cancel()
//
//    }
   
    //MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ID.segueID.rawValue  {
            let destVC = segue.destination as! UserDetailViewController
            guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
            let selectedUser = userController.users[selectedIndex.row]
            destVC.user = selectedUser
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let operation = fetchOperations[user.largeImage.absoluteString]
        queue.sync {
            operation?.cancel()
        }
    }
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {


        let user = userController.users[indexPath.row]
        
        if let cachedValue = self.cache.value(for: user.name) {
            let image = UIImage(data: cachedValue)
            cell.imageView?.image = image
            return
        }
        
        
        let fetchOp = PhotoFetchOperation(user: user)
        
        let cacheOperation = BlockOperation {
            guard let image = fetchOp.imageData else { return }
            self.cache.cache(value: image, for: user.name)
        }
        
        let addImageOperation = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell),currentIndexPath != indexPath {
                return
            }
            
            
            if let image = fetchOp.imageData {
                cell.imageView?.image = UIImage(data: image)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            
        }
        
        cacheOperation.addDependency(fetchOp)
        addImageOperation.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOperation)
        
        OperationQueue.main.addOperation(addImageOperation)
        
        fetchOperations[user.name] = fetchOp
        
        
        
        
        
        
    }
   

}



