//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

// Table View
class UsersTableViewController: UITableViewController {

    // Properties
    let usersController = UsersController()
    private var cache: Cache<String, UIImage> = Cache()
    private let operations = OperationQueue()
    private var fetchImage: [String : FetchCellImageOperation] = [:]
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersController.users.count // count by entery
    }
    
    // IBButton Action add
    @IBAction func addBarButton(_ sender: Any) {
        usersController.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell // using table view cell class

        let randomUsers = usersController.users[indexPath.row] // random user at row
        cell.textLabel?.text = randomUsers.name // name
        
        //image load at cell here
        loadingImage(forCell: cell, for: indexPath) // use loading image function

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if usersController.users.count > 0 { // cancel loading when not at display
            let user = usersController.users[indexPath.row]
            fetchImage[user.email]?.cancel()
        } else {
            for (_, operation) in fetchImage {
                operation.cancel()
            }
        }
    }
    
    // loading image to the cell function
    private func loadingImage(forCell cell: UsersTableViewCell, for indexPath: IndexPath) {
        
        let user = usersController.users[indexPath.row]
        
        if let image = cache.value(key: user.email) {
            cell.userImageView.image = image
        } else {
            let cellViewOperation = FetchCellImageOperation(user: user)
            
            let cacheOperation = BlockOperation {
                guard let image = cellViewOperation.thumbNailImage else {return}
                self.cache.cache(value: image, key: user.phone)
            }
            
            let cellUseOperation = BlockOperation {
                guard let image = cellViewOperation.thumbNailImage else {return}
                
                if self.tableView.indexPath(for: cell) == indexPath {
                    cell.userImageView.image = image
                    cell.imageView?.image = image
                    self.tableView.reloadData()
                }
            }
            
            cacheOperation.addDependency(cellViewOperation)
            cellUseOperation.addDependency(cellViewOperation)
            
            operations.addOperations([cellViewOperation, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(cellUseOperation)
            
            fetchImage[user.phone] = cellViewOperation
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let detailVC = segue.destination as? UsersDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            let users = usersController.users[indexPath.row]
            detailVC.usersController = usersController
            detailVC.user = users
        }
    }
    

}
