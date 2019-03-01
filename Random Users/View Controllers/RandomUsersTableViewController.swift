//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Paul Yi on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        randomUserController.fetchRandomUsers { (randomUsers, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.randomUsers = randomUsers
        }
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUsers?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! RandomUserTableViewCell

        let randomUser = randomUsers?[indexPath.row]
        cell.nameLabel.text = randomUser?.name
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2;
        cell.userImageView.clipsToBounds = true
        
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let randomUser = randomUsers?[indexPath.row],
            let phoneNumber = randomUser.phoneNumber else { return }
        
        activeOperations[phoneNumber]?[.thumbnail]?.cancel()
    }
    
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let randomUser = randomUsers?[indexPath.row],
            let phoneNumber = randomUser.phoneNumber else { return }
        
        if let image = cache.value(for: phoneNumber) {
            cell.userImageView?.image = image[.thumbnail]
        } else {
            let thumbnailOperation = FetchThumbnailOperation(randomUser: randomUser)
            let storeOperation = BlockOperation {
                guard let image = thumbnailOperation.thumbnailImage else { return }
                self.cache.cache(value: [.thumbnail: image], for: phoneNumber)
            }
            let nonReusedOperation = BlockOperation {
                guard let image = thumbnailOperation.thumbnailImage else { return }
                if indexPath == self.tableView.indexPath(for: cell) {
                    cell.userImageView.image = image
                }
            }
            
            storeOperation.addDependency(thumbnailOperation)
            nonReusedOperation.addDependency(thumbnailOperation)
            
            randomUserFetchQueue.addOperations([thumbnailOperation, storeOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(nonReusedOperation)
            activeOperations[phoneNumber] = [.thumbnail: thumbnailOperation]
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailView" {
            let detailVC = segue.destination as! RandomUserDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            detailVC.randomUser = randomUsers?[index.row]
        }
    }
    
    // MARK: - Properties
    
    let randomUserController = RandomUserController()
    var randomUsers: [RandomUser]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var cache: Cache<String, [RandomUser.Images: UIImage]> = Cache()
    var randomUserFetchQueue = OperationQueue()
    var activeOperations: [String: [RandomUser.Images: FetchThumbnailOperation]] = [:]

}
