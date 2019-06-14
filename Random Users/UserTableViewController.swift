//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Diante Lewis-Jolley on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    // MARK: - Properties
    let userClient = UserClient()
    var photoFetchQueue = OperationQueue()
    private var activeOperations: [String: ThumbNailOperation] = [:]
    var cache: Cache<String, UIImage> = Cache()
    var users: [User]? = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userClient.fetchUsers { (users, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }

            self.users = users
        }


    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell

        let user = users?[indexPath.row]

        cell.nameLabel.text = user?.name
        loadImage(forCell: cell, forItemAt: indexPath)



        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let user = users?[indexPath.row] else { return }

        activeOperations[user.phoneNumber]?.cancel()
    }


    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {

        guard let user = users?[indexPath.row] else { return }


        if let image = cache.value(for: user.phoneNumber) {
            cell.imageView?.image = image
        } else {

            let fetchedThumbNailOperation = ThumbNailOperation(user: user)

            let cacheOperation = BlockOperation {

                guard let image = fetchedThumbNailOperation.thumbNailImage else { return }

                self.cache.cache(value: image, for: user.phoneNumber)

            }


            let cellReusedOperation = BlockOperation {
                guard let image = fetchedThumbNailOperation.thumbNailImage else { return }
                if self.tableView.indexPath(for: cell) == indexPath {
                    cell.imageView?.image = image

                }
            }

            cacheOperation.addDependency(fetchedThumbNailOperation)
            cellReusedOperation.addDependency(fetchedThumbNailOperation)

            photoFetchQueue.addOperations([fetchedThumbNailOperation, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(cellReusedOperation)

            activeOperations[user.phoneNumber] = fetchedThumbNailOperation




        }

    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if segue.identifier == "DetailSegue" {
            guard let DetailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            DetailVC.user = users?[indexPath.row]
        }
    }



}
