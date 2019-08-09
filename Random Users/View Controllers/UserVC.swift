//
//  UserVC.swift
//  Random Users
//
//  Created by Seschwan on 8/2/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    let userController = UserController()
    
    private let cache: Cache<String, Data> = Cache()  // This is to store the thumbnails for the people. [Key: person, Value: image]
    private var operations = [String : Operation]()
    private let photoFetchQ = OperationQueue()  // This is to make sure that operations are on the right Q.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.userController.fetchUsers { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailVC" {
            guard let detailVC = segue.destination as? DetailVC,
                let indexPath = self.tableView.indexPathForSelectedRow else {print("Error selecting the indexPath in prepare for segue")
                    return
            }
            detailVC.user = self.userController.usersArray[indexPath.row]
        }
    }
    
    

}

extension UserVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userController.usersArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        print(indexPath.row)
        self.loadImage(forCell: cell, forIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userReference = self.userController.usersArray[indexPath.item]
        operations[userReference.fullName]?.cancel()
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forIndexPath indexPath: IndexPath) {
        let userReference = self.userController.usersArray[indexPath.item]
        
        if let cachedData = self.cache.returnValue(key: userReference.fullName) {
            cell.userImage.image = UIImage(data: cachedData)
            cell.userLbl.text = userReference.fullName
            return
        }
        
        let fetchUserOperation = FetchUserOperation(user: userReference)
        let cachedOperation = BlockOperation {
            if let data = fetchUserOperation.imageData {
                self.cache.cache(value: data, key: userReference.fullName)
            }
        }
        
        let checkReuseOperation = BlockOperation {
            defer { self.operations.removeValue(forKey: userReference.fullName) }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            if let imageData = fetchUserOperation.imageData {
                cell.userImage.image = UIImage(data: imageData)
                cell.userLbl.text = userReference.fullName
            }
        }
        
        cachedOperation.addDependency(fetchUserOperation)
        checkReuseOperation.addDependency(fetchUserOperation)
        
        photoFetchQ.addOperation(fetchUserOperation)
        photoFetchQ.addOperation(cachedOperation)
        OperationQueue.main.addOperation(checkReuseOperation)
        
        self.operations[userReference.fullName] = fetchUserOperation
    }
    
}

extension UserVC: UITableViewDelegate {
    
}
