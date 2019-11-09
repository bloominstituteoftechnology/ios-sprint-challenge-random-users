//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Vici Shaweddy on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    private let cache = Cache<String, UIImage>()
    private let operationCache = Cache<String, Operation>()
    private let pictureFetchQueue = OperationQueue()
    private var randomUserController = RandomUserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomUserController.getUsers { (_, _) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let user = self.randomUserController.users[indexPath.row]

        cell.textLabel?.text = user.fullName
        loadImage(forCell: cell, forItemAt: indexPath)
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
    
    // MARK: - Private
    func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = randomUserController.users[indexPath.row]
        
        // check to see if the cache already contains data for the given picture
        if let picture = cache.value(for: user.email) {
            cell.imageView?.image = picture
            return
        }
        
        let fetchOp = FetchPictureOperation(url: user.picture.thumbnail)
        
        let cacheOp = BlockOperation {
            if let picture = fetchOp.image {
                self.cache.cache(value: picture, for: user.email)
            }
        }
        
        let setOp = BlockOperation {
            DispatchQueue.main.async {
                if self.tableView.indexPath(for: cell) == indexPath {
                    cell.imageView?.image = fetchOp.image
                }
            }
        }
        
        setOp.addDependency(fetchOp)
        cacheOp.addDependency(fetchOp)
        pictureFetchQueue.addOperations([fetchOp, cacheOp, setOp], waitUntilFinished: false)
        
        self.operationCache.cache(value: fetchOp, for: user.email)
    }

}
