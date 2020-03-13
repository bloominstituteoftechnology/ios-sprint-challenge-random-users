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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
     
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
   
    //MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ID.segueID.rawValue  {
            let destVC = segue.destination as! UserDetailViewController
            guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
            let selectedUser = userController.users[selectedIndex.row]
            destVC.user = selectedUser
        }
    }
    
    
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let photoReference = userController.users[indexPath.row].thumbNailImage
        let currenUser = userController.users[indexPath.row]
        
        if let imageData = cache.value(for: photoReference.absoluteString) {
            cell.imageView?.image = UIImage(data: imageData)
            return
        }
        
        
        let photoFetchOp  = PhotoFetchOperation(photoReference: photoReference.absoluteString)
        
        let cacheOp = BlockOperation {
            if let data = photoFetchOp.imageData {
                self.cache.cache(value: data, for: photoReference.absoluteString)
            }
        }
        
        let completionOp = BlockOperation {
            defer { self.fetchOperations.removeValue(forKey: currenUser.name)}
            
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
            return
            }
            
            if let data = photoFetchOp.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        cacheOp.addDependency(photoFetchOp)
        completionOp.addDependency(photoFetchOp)
        
        photoFetchQueue.addOperation(photoFetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        fetchOperations[currenUser.name] = photoFetchOp
        
        
        
        
        
    }
    
}



