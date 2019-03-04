//
//  PersonTableViewController.swift
//  Random Users
//
//  Created by Angel Buenrostro on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class PersonTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 60
        
        self.randomUserController.fetchRandomUsers(1000) { (error) in
            print("\(self.randomUserController.people)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let person = randomUserController.people[indexPath.row]
        guard let fetchOpToCancel = operations[person.login] else { return }
        guard let largeFetchOpToCancel = largeOperations[person.login] else { return }
        fetchOpToCancel.cancel()
        largeFetchOpToCancel.cancel()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.randomUserController.people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        let person = randomUserController.people[indexPath.row]
        // Configure the cell...
        cell.nameLabel.text = person.name
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPersonDetail"{
            let cell = sender as! PersonTableViewCell
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let person = self.randomUserController.people[indexPath.row]
            let destinationVC = segue.destination as! PersonDetailViewController
            destinationVC.randomUserController = self.randomUserController
            destinationVC.person = person
            destinationVC.largeImage = cell.largeImage
        }
    }
    
    // MARK: - Private
    
    private func loadImage(forCell cell: PersonTableViewCell, forItemAt indexPath: IndexPath){
        
        let person = randomUserController.people[indexPath.row]
        
        // Check for image in cache
        if let cachedThumbnailData = thumbnailDataCache.value(for: person.login),
            let image = UIImage(data: cachedThumbnailData!),
            let cachedLargeImageData = largeImageDataCache.value(for: person.login),
            let largeImage = UIImage(data: cachedLargeImageData!)
            {
            cell.thumbnailImageView.image = image
            cell.largeImage = largeImage
            print("thumbnail and large image found in cache")
            return
        }
//        if let cachedLargeImageData = largeImageDataCache.value(for: person.login),
//            let image = UIImage(data: cachedLargeImageData!) {
//            cell.largeImage = image
//            print("large image found in cache")
//            return
//        }
        // Start an operation to fetch image data
        
        // 1.
        let fetchThumbnailOp = FetchPhotoOperation(person: person, photoType: "thumbnail")
        let fetchLargeImageOp = FetchPhotoOperation(person: person, photoType: "large")
        // 2.
        let cacheOp = BlockOperation{
            if let data = fetchThumbnailOp.imageData {
                self.thumbnailDataCache.cache(value: data, for: person.login)
            }
            if let data = fetchLargeImageOp.imageData {
                self.largeImageDataCache.cache(value: data, for: person.login)
            }
        }
        // 3.
        let completionOp = BlockOperation{
            defer { self.operations.removeValue(forKey: person.login)
                    self.largeOperations.removeValue(forKey: person.login)
            }
            
            if let currentIndexPath = self.tableView?.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("Got image for now-reused cell")
                return
            }
            
            if let data = fetchThumbnailOp.imageData {
                cell.thumbnailImageView.image = UIImage(data: data)
            }
            if let data = fetchLargeImageOp.imageData {
                cell.largeImage = UIImage(data: data)
            }
        }
        
        let photoFetchQueue = OperationQueue()
        
        cacheOp.addDependency(fetchThumbnailOp)
        cacheOp.addDependency(fetchLargeImageOp)
        completionOp.addDependency(fetchThumbnailOp)
        completionOp.addDependency(fetchLargeImageOp)
        
        photoFetchQueue.addOperation(fetchThumbnailOp)
        photoFetchQueue.addOperation(fetchLargeImageOp)
        photoFetchQueue.addOperation(cacheOp)
        
        OperationQueue.main.addOperation(completionOp)
        
        operations[person.login] = fetchThumbnailOp
        largeOperations[person.login] = fetchLargeImageOp
    }
    
    
    // MARK: - Properties
    var operations: [UUID: FetchPhotoOperation] = [:]
    var largeOperations: [UUID: FetchPhotoOperation] = [:]
    
    private let thumbnailDataCache = Cache<UUID, Data?>()
    private let largeImageDataCache = Cache<UUID, Data?>()
    
    let randomUserController = RandomUserController()

}
