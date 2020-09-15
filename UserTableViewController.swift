//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Craig Belinfante on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    let networkController = NetworkController()
    let imageFetchQueue = OperationQueue()
    
    var users: [User] = []
    var cache = Cache<String,Data>()
    var operations: [String: FetchPhotoOperation] = [:]
    
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    //    tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        networkController.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return networkController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {fatalError("Cannot deque cell")}

        // Configure the cell...
        cell.user = networkController.users[indexPath.row]
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            operations[networkController.users[indexPath.item].name]?.cancel()
        }

    func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
       
        // 💩💩💩💩💩💩💩💩
        
        let user = networkController.users[indexPath.item]
        
        if let cachedData = cache.value(forKey: user.thumbnail) {
            cell.imageView?.image = UIImage(data: cachedData)
          //  cell.textLabel?.text = user.name
        } else {
            let fetchOp = FetchPhotoOperation(user: user, image: .thumbnail)
            let cachedImage = BlockOperation {
                if let data = fetchOp.imageData {
                    self.cache.cache(value: data, forKey: user.thumbnail)
                }
            }
            let imageUpdated = BlockOperation {
                if let data = fetchOp.imageData {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                       // cell.textLabel?.text = user.name
                    }
                }
            }
            cachedImage.addDependency(fetchOp)
            imageUpdated.addDependency(fetchOp)
            imageFetchQueue.addOperations([fetchOp,cachedImage,imageUpdated], waitUntilFinished: false)
            operations[user.thumbnail] = fetchOp
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUser" {
            if let userVC = segue.destination as? UserViewController, let indexPath = tableView.indexPathForSelectedRow {
                userVC.user = networkController.users[indexPath.row]
            }
        }
    }
}

