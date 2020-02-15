//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Austin Potts on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    var userController = UserController()
    
    private var thumbnailCache = Cache<String, Data>()
    private let imageFetchQueue = OperationQueue()
    private var storedFetchOp = [String:FetchPhotoOperation]()
    private let cancelQueue = DispatchQueue(label: "CancelOperation")
    
    override func viewDidLoad() {
       super.viewDidLoad()
                   userController.getUsers { (error) in
                       if let error = error {
                           NSLog("Error getting users for TableView: \(error)")
                       }
                       
                       DispatchQueue.main.async {
                           self.tableView.reloadData()
                       }
                   }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return userController.user.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTVCell else {return UITableViewCell()}

                let user = userController.user[indexPath.row]
               // cell.textLabel?.text = user.name.first.capitalized + " " + user.name.last.capitalized
                
               let cacheKey = user.picture.thumbnail.absoluteString
                
               cell.user = user
                
                if let imageData = thumbnailCache.value(for: cacheKey) {
                    cell.imageData = imageData
                } else {
                    let fetchPhotoOp = FetchPhotoOperation(user: user)
                    
                    let cacheOp = BlockOperation {
                        
                        if let imageData = fetchPhotoOp.imageData {
                            
                            self.thumbnailCache.cache(value: imageData, for: cacheKey)
                        }
                    }
                    
                    let cellCheckOp = BlockOperation {
                        if let cellPath = tableView.indexPath(for: cell), cellPath != indexPath {
                            return
                        }
                        if let imageData = fetchPhotoOp.imageData {
                           cell.imageData = imageData
                        }
                    }
                    
                    cacheOp.addDependency(fetchPhotoOp)
                    cellCheckOp.addDependency(fetchPhotoOp)
                    imageFetchQueue.addOperations([fetchPhotoOp, cacheOp], waitUntilFinished: false)
                    OperationQueue.main.addOperation(cellCheckOp)
                    
                    storedFetchOp.updateValue(fetchPhotoOp, forKey: user.name.first)
                    
                }
                
                return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "ShowUserSegue" {
          guard let userDetailVC = segue.destination as? UserDetailViewController else {return}
          guard let indexPath = tableView.indexPathForSelectedRow else {return}
          let user = userController.user[indexPath.row]
          userDetailVC.user = user
            }
        }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.user[indexPath.item]
        guard let fetchOp = storedFetchOp[user.name.first] else { return }
        
        cancelQueue.sync {
            fetchOp.cancel()
        }
    }
    
}
