//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Stephanie Ballard on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties -
    let randomUsersApiController = RandomUsersApiController()
    private let photoFetchQueue = OperationQueue()
    private let cache = Cache<String, Data>() //pay attention to data type that is pulled in, must be hashable and used as the key (where Int is)
    private var operations = [String : Operation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUsersApiController.users.count
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = randomUsersApiController.users[indexPath.row] // change to model name
        
        // Check if there is cached data
        if let cachedData = cache.value(key: user.email), // change to phone number or email. both need to be the same
            let image = UIImage(data: cachedData) {
            cell.imageView?.image = image
            return
        }
        
        // Start our fetch operations
        let fetchOp = FetchPhotoOperation(user: user) // change to the
        
        // saving
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(key: user.email, value: data) // can change id to phonenumber or email
            }
        }
        
        // populating the image
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: user.email) } //switch id to email or phone numbers same as funcs above
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                // refering to the for item at indexpath that is passed in above, not in the line of code below
                currentIndexPath != indexPath {
                print("Got image for reused cell")
                return
            }
            
            if let data = fetchOp.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
    }
        
         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
         // Configure the cell...
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
        
        /*
         // MARK: - Navigation
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
}
