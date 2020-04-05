//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    let userController = UserController()
    var randomUsers = [User]()
    var userQueue = OperationQueue()
    var imageLoadOperations: [IndexPath : Operation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchRandomUsers { result in
            switch result {
            case .success(let randomUsers):
                self.randomUsers = randomUsers
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            as? UserTableViewCell else { return UITableViewCell() }
        
        let user = randomUsers[indexPath.row]
        cell.user = user

        let imageFetch = ImageFetchOperation(userController: userController, url: user.thumbnail)
        let updateImagesOp = BlockOperation {
            guard let image = imageFetch.image else { return }
            cell.thumbnailImageView.image = image
            //let _ = self.imageLoadOperations.removeValue[forKey: indexPath]
        }
        updateImagesOp.addDependency(imageFetch)
        userQueue.addOperation(imageFetch)
        OperationQueue.main.addOperation(updateImagesOp)
        
        imageLoadOperations[indexPath] = imageFetch
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let operation = imageLoadOperations[indexPath] {
            print("Operation cancelled")
            operation.cancel()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showUserDetailSegue":
            guard let userDetailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            userDetailVC.userController = userController
            userDetailVC.user = randomUsers[indexPath.row]
        default:
            break
        }
    }
}
