//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
   
    
    
    // MARK: -View states
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.randomUsers?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUserCell", for: indexPath) as! UsersTableViewCell
        
        // Get the users
        let randomUser = randomUsers?[indexPath.row]
        
        // Get the user name
       // cell.userNameLabel.text = randomUser?.name
        cell.userNameLabel.text = randomUser?.name
        
        // Get the user's image
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    // Cancel operation
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    
    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let randomUser = randomUsers?[indexPath.row],
            let phoneNumber = randomUser.phoneNumber else { return }
        
        if let image = cache.value(for: phoneNumber) {
            cell.userImageView?.image = image[.thumbnail]
        } else {
            let thumbnailOperation = ThumbnailFetch(randomUser: randomUser)
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
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Add button action
    @IBAction func addUsersButtonTapped(_ sender: Any) {
        randomUserController.fetchRandomUsers { (randomUsers, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.randomUsers = randomUsers
        }
    }
    
    
    // MARK: - Properties
    let randomUserController = RandomUserController()
    var cache: Cache<String, [RandomUser.UserImages: UIImage]> = Cache()
    var randomUserFetchQueue = OperationQueue()
    var activeOperations: [String: [RandomUser.UserImages: ThumbnailFetch]] = [:]
    
    var randomUsers: [RandomUser]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    

}


