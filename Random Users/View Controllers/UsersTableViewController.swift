//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Chad Parker on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    private var users: [User] = [] {
        didSet {
            print("\(users.count) users")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let thumbnailCache = Cache<URL, UIImage>()
    private let thumbnailFetchQueue = OperationQueue()
    private var thumbnailFetchOperations: [URL: FetchImageOperation] = [:]
    private let userAPIController = UserAPIController()

    @IBAction func addUsers(_ sender: UIBarButtonItem) {
        userAPIController.getUsers { result in
            switch result {
            case .success(let users):
                self.users.append(contentsOf: users)
            case .failure(let networkError):
                print("NetworkError: \(networkError)")
            }
        }
    }
    
    private func loadThumbnail(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        let url = user.picture.thumbnail
        
        if let cachedImage = thumbnailCache.value(for: url) {
            DispatchQueue.main.async {
                cell.userImageView.image = cachedImage
            }
        } else {
            let fetchThumbnailOperation = FetchImageOperation(url: url)
            
            let cacheThumbnailOperation = BlockOperation {
                DispatchQueue.main.async {
                    guard let image = fetchThumbnailOperation.uiImage else { return }
                    self.thumbnailCache.cache(value: image, for: url)
                }
            }
            cacheThumbnailOperation.addDependency(fetchThumbnailOperation)
            
            let setImageIfCellNotReused = BlockOperation {
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                        currentIndexPath != indexPath {
                        return
                    }
                    guard let image = fetchThumbnailOperation.uiImage else { return }
                    cell.userImageView.image = image
                }
            }
            setImageIfCellNotReused.addDependency(fetchThumbnailOperation)
            
            thumbnailFetchQueue.addOperations([
                fetchThumbnailOperation,
                cacheThumbnailOperation,
                setImageIfCellNotReused,
            ], waitUntilFinished: false)
            
            thumbnailFetchOperations[url] = fetchThumbnailOperation
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell

        let user = users[indexPath.row]
        loadThumbnail(forCell: cell, forItemAt: indexPath)
        cell.userNameLabel.text = user.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let url = user.picture.thumbnail
        if let fetchOperation = thumbnailFetchOperations[url] {
            fetchOperation.cancel()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userDetailVC = segue.destination as? UserDetailViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            userDetailVC.user = users[indexPath.row]
        }
    }
}
