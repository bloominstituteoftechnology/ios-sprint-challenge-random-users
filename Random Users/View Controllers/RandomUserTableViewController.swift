//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Thomas Cacciatore on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomUserController.fetchUsers { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? RandomUserTableViewCell else { fatalError("Unable to dequeue cell") }

//        let user = randomUserController.users[indexPath.row]
//        cell.user = user
        loadImage(forCell: cell, forItemAt: indexPath)
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userRef = randomUserController.users[indexPath.item]
        operations[userRef.name]?.cancel()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let destinationVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = randomUserController.users[indexPath.row]
            destinationVC.user = user
        }
    }
    
    
    func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        let userReference = randomUserController.users[indexPath.item]
       
        if let cachedImageData = cache.value(for: userReference.name),
            let image = UIImage(data: cachedImageData) {
            cell.imageView?.image = image
            cell.cellNameLabel.text = userReference.name
            return
        }
        
        let fetchOp = FetchUserOperation(user: userReference)
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, for: userReference.name)
            }
        }
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: userReference.name) }
            
            if let currentIndexPath = self.tableView?.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            if let data = fetchOp.imageData {
                cell.imageView?.image = UIImage(data: data)
                cell.cellNameLabel.text = userReference.name
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        userFetchQueue.addOperation(fetchOp)
        userFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[userReference.name] = fetchOp
    }

    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    private let userFetchQueue = OperationQueue()
    
    var randomUserController = RandomUserController()
}
