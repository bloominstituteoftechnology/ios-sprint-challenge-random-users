//
//  RandomTableViewController.swift
//  Random Users
//
//  Created by Yvette Zhukovsky on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchRandomUserController.fetchUsers { (randomUsers, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            self.randomUsers = randomUsers
        }
        
        
    }

    // MARK: - Table view data source


    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUsers?.count ?? 0
    }


    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let ranUser = randomUsers?[indexPath.row] else {return}
       guard let phone = ranUser.phone else { return }
        
        activeOperations[phone]?[.thumbnail]?.cancel()
    }
    
    
  
    private func loadingImages(forCell cell: RandomTableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let randomUser = randomUsers?[indexPath.row],
            let phone = randomUser.phone else { return }
        
        if let image = cache.value(for: phone) {
            cell.userImage.image = image[.thumbnail]
        } else {
            let thumbnailOperation = FetchingThumbnails(randomUsers: randomUser)
            let storingOperation = BlockOperation {
                guard let image = thumbnailOperation.thumbail else { return }
                self.cache.cache(value: [.thumbnail: image], for: phone)
            }
            let nonReusedOperation = BlockOperation {
                guard let image = thumbnailOperation.thumbail else { return }
                if indexPath == self.tableView.indexPath(for: cell) {
                    cell.userImage.image = image
                }
            }
            
            storingOperation.addDependency(thumbnailOperation)
            nonReusedOperation.addDependency(thumbnailOperation)
            
            userFetch.addOperations([thumbnailOperation, storingOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(nonReusedOperation)
            activeOperations[phone] = [.thumbnail: thumbnailOperation]
        }
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RandomTableViewCell

   let user = randomUsers?[indexPath.row]
        cell.userName.text = user?.name
        loadingImages(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
   
    

    
 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            let detailVC = segue.destination as! RandomDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            detailVC.randomUser = randomUsers?[index.row]
        }
    }
        
        
        

    
    
    
    let fetchRandomUserController = FetchRandomUsersController()
    var userFetch = OperationQueue()
     var cache: Cache<String, [RandomUser.Images: UIImage]> = Cache()
    var randomUsers: [RandomUser]?
    {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
   var activeOperations: [String: [RandomUser.Images: FetchingThumbnails]] = [:]
    
    
}
