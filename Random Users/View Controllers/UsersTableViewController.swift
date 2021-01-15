//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    var userController = UserController()
    
    private let cache = Cache<String, Data>()
    private let imageQueue = OperationQueue()
    
    var operation = [String : Operation]()

    var users: [UsersResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers { (results) in
            do {
                let users = try results.get()
                DispatchQueue.main.async {
                    self.users = users.results
                }
            } catch {
                print(results)
            }

        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print("Cell 2")
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as? UsersTableViewCell else { return UITableViewCell()}

            updateCell(forCell: cell, forItemAt: indexPath)
        
        return cell
    }

    func updateCell(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        
        cell.usersNameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        
        if let cacheData = cache.getValue(for: user.email),
           let image = UIImage(data: cacheData) {
            cell.userImageView.image = image
            return
        }
        
        let fetchImageOperation = FetchImageOperation(user: user)
        let store = BlockOperation {
            guard let data = fetchImageOperation.imageData else { return }
            self.cache.cache(value: data, for: user.email)
        }
        
        let isReused = BlockOperation {
//            guard let data = fetchImageOperation.imageData else { return }
//
//            defer {
//                self.operation.removeValue(forKey: user.email)
//            }
//
//            if let currentPath = self.tableView.indexPath(for: cell), currentPath != indexPath {
//                return
//            }
//
//            cell.userImageView.image = UIImage(data: data)
            
            defer {
                self.operation.removeValue(forKey: user.email)
            }

            if let currentPath = self.tableView.indexPath(for: cell), currentPath != indexPath {
                return
            }
            if let someimage = fetchImageOperation.imageData {
                cell.userImageView.image = UIImage(data: someimage)
            }
        }
        
        store.addDependency(fetchImageOperation)
        isReused.addDependency(fetchImageOperation)
//        imageQueue.addOperation(fetchImageOperation)
//        imageQueue.addOperation(store)
        imageQueue.addOperations([fetchImageOperation, store], waitUntilFinished: false)
//        OperationQueue.main.addOperation(isReused)
        OperationQueue.main.addOperations([isReused], waitUntilFinished: false)
//        self.operation[user.email] = fetchImageOperation
        self.operation.updateValue(fetchImageOperation, forKey: String(user.email))

        
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentOperation = users[indexPath.row]
        guard let newOperation = operation[currentOperation.email] else { return }
        newOperation.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UsersDetailSegue" {
            if let detialVC = segue.destination as? DetailViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                detialVC.userController = userController
                detialVC.userResults = users[indexPath.row
                ]
            }
        }
    }

}

