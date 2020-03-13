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
    var fetchResults: [UUID: FetchPhotoOperation] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.user = user
        cell.userClient = userClient
        loadImage(forCell: cell,
                  forItemAt: indexPath)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
