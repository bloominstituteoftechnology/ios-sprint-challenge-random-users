//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Rob Vance on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // Properties
    let randomUserApiCon = RandomUsersApiController()
    private let imageFetchQueue = OperationQueue()
    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.randomUserApiCon.fetchUsers { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = randomUserApiCon.users[indexPath.row]
        
        if let cacheData = cache.value(for: user.email),
            let image = UIImage(data: cacheData) {
            cell.imageView?.image = image
            return
        }
        let fetchOperation = FetchImageOperation(user: user)
        
        
        let cacheOperation = BlockOperation {
            if let data = fetchOperation.imageData {
                self.cache.cache(key: user.email, value: data)
            }
        }
        
        let completionOperation = BlockOperation {
            //switch id to email or phone numbers same as funcs above
            defer { self.operations.removeValue(forKey: user.email) }
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("Got Image")
                return
            }
            if let data = fetchOperation.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        cacheOperation.addDependency(fetchOperation)
        completionOperation.addDependency(fetchOperation)
        imageFetchQueue.addOperation(fetchOperation)
        imageFetchQueue.addOperation(cacheOperation)
        operations[user.email] = fetchOperation
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserApiCon.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UserTableViewCell() }
        let user = randomUserApiCon.users[indexPath.row]
        cell.user = user
        loadImage(forCell: cell, forItemAt: indexPath)

        // Configure the cell...

        return cell
    }
   
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let thumbnailReference = randomUserApiCon.users[indexPath.row]
        operations[thumbnailReference.thumbnailImage.absoluteString]?.cancel()
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            guard let detailVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.user = randomUserApiCon.users[indexPath.row]
        }
    }
}

