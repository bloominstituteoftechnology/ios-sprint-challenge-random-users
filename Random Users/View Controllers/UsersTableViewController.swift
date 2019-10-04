//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Marc Jacques on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//
import Foundation
import UIKit

class UsersTableViewController: UITableViewController {
    
    private let cache = Cache<String, UIImage>()
    private let photoFetchQ = OperationQueue()
    
    
    var apiController = APIController()
    
       
    override func viewDidLoad() {
           super.viewDidLoad()
           
           apiController.getUsers { (error) in
               if let error = error {
                   NSLog("Error performing data task: \(error)")
               }
               DispatchQueue.main.async { //when you finish the netowrking tasks you go back to the main qeue
                   self.tableView.reloadData()
               }
             }
            }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return apiController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = apiController.users[indexPath.row]
               
               cell.textLabel?.text = user.name.first.capitalized + " " + user.name.last.capitalized
               guard let imageData = try? Data(contentsOf: user.picture.thumbnail) else { fatalError() }
               cell.imageView?.image = UIImage(data: imageData)
               return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let photoReference = apiController.users[indexPath.item]
        
        // Check if there is cached data
        if let cachedData = cache.value(for: photoReference.email) {
            
            cell.imageView?.image = cachedData
            return
        }
        
        // Start our fetch operations
        let fetchOp = FetchPhotoOperation(userPicture: photoReference.picture)
        
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: , for: photoReference.email)
            }
        }
        
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: photoReference.id) }
            if let currentIndexPath = self.collectionView.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("Got image for reused cell")
                return
            }
            if let data = fetchOp.imageData {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[photoReference.id] = fetchOp
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "UserDetail" {
        guard let userDetailVC = segue.destination as? UserDetailViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
         // Pass the selected object to the new view controller.
        let user = apiController.users[indexPath.row]
        userDetailVC.user = user
   
        }
    }
}
