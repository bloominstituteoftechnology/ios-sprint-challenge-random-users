//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    let userController = UserController()
    private var cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    private var fetchDictionary: [String: FetchPhotoOperation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        cell.user = userController.users[indexPath.row]
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? UserTableViewCell {
            let task = fetchDictionary[cell.userID]
            task?.cancel()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailShowSegue" {
            if let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.user = userController.users[indexPath.row]
            }
        }
    }
    
    // MARK: - Functions
    
    @IBAction func addUsersButton(_ sender: UIBarButtonItem) {
        userController.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = userController.users[indexPath.item]
        let userID = user.email
        cell.userID = userID
        if let imageData = cache[userID] {
            cell.thumbnailImageView?.image = UIImage(data: imageData)
        } else {
            let fetchImage = FetchPhotoOperation(user: user, imageType: .thumbnail)
            let cacheImage = BlockOperation {
                if let data = fetchImage.imageData {
                    self.cache.cache(key: userID, value: data)
                }
            }
            let setImage = BlockOperation {
                if let data = fetchImage.imageData {
                    DispatchQueue.main.async {
                        guard cell.userID == userID else { return }
                        cell.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }
            cacheImage.addDependency(fetchImage)
            setImage.addDependency(fetchImage)
            photoFetchQueue.addOperations([fetchImage, cacheImage, setImage], waitUntilFinished: false)
            fetchDictionary[userID] = fetchImage
        }
    }

}
