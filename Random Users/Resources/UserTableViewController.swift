//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Chris Gonzales on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let photoFetchQueue = OperationQueue()
    private let cache: Cache<UUID, UIImage> = Cache()
    let userController = UserController()
    let userClient = UserClient()
    var fetchResults: [UUID: Operation] = [:]
    
    @IBOutlet var thumbnailImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userClient.fetchUsers { (error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Keys.userCellID, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = userController.users[indexPath.row]
        loadImage(forCell: cell,
                  forItemAt: indexPath)
        let firstName = user.first.capitalized
        let lastName = user.last.capitalized
        let fullName = "\(firstName) \(lastName)"
        
        nameLabel.text = fullName
        
        userClient.fetchPictures(for: user.thumbnail) { (result) in
            if let result = try? result.get() {
                DispatchQueue.main.async {
                    let image = UIImage(data: result)
                    self.thumbnailImage.image = image
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let user = userController.users[indexPath.row]
        
        guard let userUUID = UUID(uuidString: fetchResults[user.id]),
            let fetchRestults = fetchResults[userUUID] else { return }
        fetchResults.cancel()
    }
    
    // MARK: - Private Methods
    
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = userController.users[indexPath.row]
        
        guard let userUUID = UUID(uuidString: user.id) else { return }
        if let image = cache.value(for: userUUID) {
            cell.imageView?.image = image
        } else {
            let fetchPhotoOperation = FetchPhotoOperation(photoString: user.thumbnail)
            let saveToCacheOperation = BlockOperation {
                guard let imageData = fetchPhotoOperation.imageData else { return }
                guard let image = UIImage(data: imageData) else { return }
                self.cache.cache(value: image,
                                 for: userUUID)
            }
            let checkResuseOperation = BlockOperation {
                if indexPath == self.tableView.indexPath(for: cell){
                    guard let imageData = fetchPhotoOperation.imageData else { return }
                    guard let image = UIImage(data: imageData) else { return }
                    cell.imageView?.image = image
                }
            }
            
            saveToCacheOperation.addDependency(fetchPhotoOperation)
            checkResuseOperation.addDependency(fetchPhotoOperation)
            photoFetchQueue.addOperations([fetchPhotoOperation,
                                           saveToCacheOperation],
                                          waitUntilFinished: false)
            OperationQueue.main.addOperation(checkResuseOperation)
            
            fetchResults[userUUID] = fetchPhotoOperation
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.userDetailSegue {
            guard let detailVC = segue.destination as? UserDetailViewController else { return }
            detailVC.userClient = userClient
            detailVC.user = userController.users[tableView.indexPathForSelectedRow!]
        }
    }
}
