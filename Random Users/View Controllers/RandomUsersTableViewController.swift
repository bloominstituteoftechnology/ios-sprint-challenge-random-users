//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Moin Uddin on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        userController.getUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath)
        let user = userController.users[indexPath.row]
        loadImage(forCell: cell, forItemAt: indexPath)
        cell.prepareForReuse()
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let fetchImageOperation = operations[userController.users[indexPath.item].phoneNumber] else { return }
        fetchImageOperation.cancel()
    }
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        
        if let image = cache.value(for: user.phoneNumber) {
            cell.imageView?.image = UIImage(data: image)
            print("Image used from cached")
            return
        }
        
        let fetchImageOperation = FetchImageOperation(user: user)
        
        let cacheOperation = BlockOperation {
            guard let imageData = fetchImageOperation.imageData else { return }
            self.cache.cache(value: imageData, for: user.phoneNumber)
        }
        
        let setImageAndUpdateUIOperation = BlockOperation {
            
            DispatchQueue.main.async {
                guard let imageData = fetchImageOperation.imageData else { return }
                print("Image is fetched")
                if self.tableView.indexPath(for: cell) == indexPath {
                    let image = UIImage(data: imageData)
                    cell.imageView?.image = image
                    cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
                    //self.tableView.reloadData()
                }
            }
        }
        
        cacheOperation.addDependency(fetchImageOperation)
        setImageAndUpdateUIOperation.addDependency(fetchImageOperation)
        
        operations[user.phoneNumber] = fetchImageOperation
        
        
        imageFetchQueue.addOperations([fetchImageOperation, cacheOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(setImageAndUpdateUIOperation)
        
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ViewUser" {
            guard let destVC = segue.destination as? RandomUserDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.users[indexPath.row]
            destVC.user = user
        }
    }
    
    let userController = UserController()
    private var cache = Cache<String, Data>()
    private var imageFetchQueue = OperationQueue()
    private var operations = [String: FetchImageOperation]()

}
