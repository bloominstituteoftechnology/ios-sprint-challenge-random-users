//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Isaac Lyons on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    private var userController = UserController()
    private let cache = Cache<Int, UIImage>()
    private let photoFetchQueue = OperationQueue()
    private var fetchOperations: [Int: FetchPhotoOperation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print("About to fetch users.")
        userController.fetchUsers { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        cell.textLabel?.text = userController.users[indexPath.row].name
        loadImage(for: cell, forItemAt: indexPath)

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
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchOperations[indexPath.row]?.cancel()
    }
    
    //MARK: Private
    
    private func loadImage(for cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let photoReference = userController.users[indexPath.row].thumbnailURL
        
        if let image = cache.value(for: indexPath.row) {
            cell.imageView?.image = image
        } else {
            let fetchOperation = FetchPhotoOperation(reference: photoReference)
            
            let saveToCache = BlockOperation {
                guard let image = UIImage(data: fetchOperation.imageData ?? Data()) else { return }
                self.cache.cache(value: image, for: indexPath.row)
            }
            
            let setCellImage = BlockOperation {
                guard let image = UIImage(data: fetchOperation.imageData ?? Data()) else { return }
                if self.tableView.indexPath(for: cell) == indexPath {
                    cell.imageView?.image = image
                }
            }
            
            saveToCache.addDependency(fetchOperation)
            setCellImage.addDependency(fetchOperation)
            
            photoFetchQueue.addOperations([fetchOperation, saveToCache], waitUntilFinished: false)
            OperationQueue.main.addOperations([setCellImage], waitUntilFinished: false)
            
            fetchOperations[indexPath.row] = fetchOperation
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

}
