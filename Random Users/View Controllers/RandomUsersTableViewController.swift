//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {

    var randomUserController = RandomUserController()
    private let fetchImageQueue = OperationQueue()
    private let cache = Cache<URL, Data>()
    var fetchImageOperations = [URL: FetchImageOperation]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomUserController.fetchRandomUsers() {_ in
            DispatchQueue.main.async{ self.tableView.reloadData() }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUserController.randomUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUser", for: indexPath) as! RandomUserTableViewCell
        cell.randomUser = randomUserController.randomUsers[indexPath.row]
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    // MARK: - Private
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        let randomUser = randomUserController.randomUsers[indexPath.row]
        
        if let imageData = cache.getValue(key: randomUser.thumbnail) {
            let image = UIImage(data: imageData)
            cell.randomUsersImageView.image = image
            return
        }
        
        let fetchImageOperation = FetchImageOperation(randomUser: randomUser)
        let cacheImageBlockOperation = BlockOperation {
            self.cache.setValue(for: randomUser.picture, value: fetchImageOperation.imageData!)
        }
        
        let fetchImageBlockOperation = BlockOperation {
            if let imageData = fetchImageOperation.imageData {
                let image = UIImage(data: imageData)
                cell.randomUsersImageView.image = image
            }
        }
        
        cacheImageBlockOperation.addDependency(fetchImageOperation)
        fetchImageBlockOperation.addDependency(fetchImageOperation)
        fetchImageOperations[randomUser.thumbnail] = fetchImageOperation
        
        fetchImageQueue.addOperation(fetchImageOperation)
        fetchImageQueue.addOperation(cacheImageBlockOperation)
        OperationQueue.main.addOperation(fetchImageBlockOperation)
        fetchImageQueue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRandomUser" {
            let randomUserViewController = segue.destination as! RandomUserViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let randomUser = randomUserController.randomUsers[indexPath.row]
                randomUserViewController.randomUser = randomUser
            }
        }
    }
    
    
    
}
