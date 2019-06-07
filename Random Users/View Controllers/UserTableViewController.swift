//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Christopher Aronson on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    var listOfUsers: RandomUser?

    override func viewDidLoad() {
        
        let userFetchQueue = OperationQueue()
        
        let getRandomUsersOp = RandomUserController()
        
        let loadUsersToTable = BlockOperation {
            self.listOfUsers = getRandomUsersOp.users
        }
        
        let reloadTableview = BlockOperation {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        loadUsersToTable.addDependency(getRandomUsersOp)
        reloadTableview.addDependency(loadUsersToTable)
        
        userFetchQueue.addOperations([getRandomUsersOp, loadUsersToTable, reloadTableview], waitUntilFinished: false)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfUsers?.results.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        guard let userForThisCell = listOfUsers?.results[indexPath.row] else { return UITableViewCell()}

        cell.textLabel?.text = "\(userForThisCell.name.title) \(userForThisCell.name.first) \(userForThisCell.name.last)"
        
        loadThumbnail(forCell: cell, forItemAt: indexPath)
        
        

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
    
    private func loadThumbnail(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let thumbnaillUrl = URL(string: listOfUsers?.results[indexPath.row].picture.thumbnail) else { return }
        var imageData: Data?
        let indexPatchForCell = indexPath
        // TODO: Implement image loading here
        
        if let imageData = cache.value(for: photoReference.id) {
            cell.imageView.image = UIImage(data: imageData)
        } else {
            
            let fetchImageDataOp = FetchPhotoOperation(marsPhotoReference: photoReference)
            
            fetchImageDataOp.completionBlock = {
                self.fetchDictionary.updateValue(fetchImageDataOp, forKey: photoReference.id)
            }
            
            let getDataOp = BlockOperation {
                imageData = fetchImageDataOp.outputImageData
            }
            
            let cacheImageOp = BlockOperation {
                guard let data = imageData else { return }
                self.cache.cache(value: data, for: photoReference.id)
            }
            
            let displayOp = BlockOperation {
                indexLock.lock()
                if fetchImageDataOp.marsPhotoReference.id == photoReference.id {
                    DispatchQueue.main.async {
                        guard let data = imageData else { return }
                        cell.imageView.image = UIImage(data: data)
                    }
                }
                indexLock.unlock()
            }
            
            getDataOp.addDependency(fetchImageDataOp)
            cacheImageOp.addDependency(getDataOp)
            displayOp.addDependency(getDataOp)
            
            photoFetchQueue.addOperations([fetchImageDataOp, getDataOp, cacheImageOp, displayOp], waitUntilFinished: false)
        }
    }

}
