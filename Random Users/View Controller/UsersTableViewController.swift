//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let segueIdentifier = "CellShowSegue"
    let cellIdentifier = "TableCell"
    let userController = UserController()
    var randomUserFetchQueue = OperationQueue()
    var activeOperations: [String : [User.Pictures : FetchThumbnailImageOperation]] = [:]
    var cache: Cache<String, [User.Pictures: UIImage]> = Cache()
    
    // Computed
    var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.prepareForReuse()
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let destinationVC = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.user = users?[indexPath.row]
        }
    }
    
    // MARK: - Load image
    
    func loadImage(for cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row],
            let phone = user.phone else { return }
        
        if let image = cache.value(forKey: phone) {
            cell.imageView?.image = image[.thumbnail]
        } else {
            let thumbnailOperation = FetchThumbnailImageOperation(user: user)
            
            let storeOperation = BlockOperation {
                guard let image = thumbnailOperation.thumbnailImage else { return}
                self.cache.cache(value: [.thumbnail: image], forKey: phone)
            }
            
            let nonReusedOperation = BlockOperation {
                guard let image = thumbnailOperation.thumbnailImage else { return }
                if indexPath == self.tableView.indexPath(for: cell) {
                    cell.imageView?.image = image
                }
            }
            
            storeOperation.addDependency(thumbnailOperation)
            nonReusedOperation.addDependency(thumbnailOperation)
            
            randomUserFetchQueue.addOperations([thumbnailOperation, storeOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(nonReusedOperation)
            activeOperations[phone] = [.thumbnail:thumbnailOperation]
        }
        
    }
}
