//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    // MARK: - Properties
    var randomUsersController = RandomUsersController()
    var users: [UserResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let cache = Cache<String, Data>()
    
    private let photoFetchQueue = OperationQueue()
    var operation = [String: Operation]()
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell()}

        updateCell(forCell: cell, forItemAt: indexPath)
//        let user = users[indexPath.row]
//        cell.user = user

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentFetchOperation = users[indexPath.row]
        guard let thisOperation = operation[currentFetchOperation.email] else { return }
        thisOperation.cancel()
    }

    //MARK: - Load Images
    func updateCell(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        cell.userNameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        
        //check the cache before calling function
        if let cacheData = cache.value(for: user.email),
            let image = UIImage(data: cacheData) {
            cell.userImageView.image = image
            return
        }
        
        let photoFetchOperation = FetchUserPhotoOperation(userReference: user)
        let store = BlockOperation {
            guard let data = photoFetchOperation.imageData else { return }
            self.cache.cache(value: data, for: user.email)
        }

        let isReused = BlockOperation {
            guard let data = photoFetchOperation.imageData else { return }
            cell.userImageView.image = UIImage(data: data)
        }
        
        store.addDependency(photoFetchOperation)
        isReused.addDependency(photoFetchOperation)
        
        
        photoFetchQueue.addOperation(photoFetchOperation)
        photoFetchQueue.addOperation(store)
        OperationQueue.main.addOperation(isReused)
        operation[user.email] = photoFetchOperation
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
            let userDetailVC = segue.destination as? UserDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
                userDetailVC.randomUser = users[selectedIndexPath.row]
            }
    }
    
    // MARK: - IBAction
    
    @IBAction func addUsersButtonPressed(_ sender: Any) {
        randomUsersController.getUsers { (results) in
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
    
}
