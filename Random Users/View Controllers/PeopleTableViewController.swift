//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Karen Rodriguez on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let peopleController = PeopleController()
    let photoFetchQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        peopleController.fetchPeople() { _ in
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peopleController.people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PersonTableViewCell else { fatalError() }

        // Configure the cell...
        
        cell.nameLabel.text = peopleController.people[indexPath.row].fullName()
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
    
    // MARK: - Methods
    
    private func loadImage(forCell cell: PersonTableViewCell, forItemAt indexPath: IndexPath) {
            
        let person = peopleController.people[indexPath.item]
    //         TODO: Implement image loading here
            
        let fetchOp = FetchPhotoOperation(personReference: person, requestType: .thumbnail)
        let storeCache = BlockOperation {
            if let data = fetchOp.imageData {
                print("Was able to get image data from fetch operation")
//                self.cache.cache(value: data, for: photoReference.id)
            } else {
                print("NO DATA TO STORE IN STORECAHCE OP")
            }
                
        }
        storeCache.addDependency(fetchOp)
            
        let lastOp = BlockOperation {
            print("Last OP called.")
//            guard let data = fetchOp.imageData,
//                    cell.photoId == photoReference.id else {
//                    print("Couldn't cast cell and/or get data")
//                    return
//                }
//                cell.imageView.image = UIImage(data: data)
        }
        lastOp.addDependency(fetchOp)
        
        
        
        photoFetchQueue.addOperations([fetchOp, storeCache], waitUntilFinished: false)
        OperationQueue.main.addOperation(lastOp)
            
            
//            if opDic[photoReference.id] == nil {
//                opDic[photoReference.id] = fetchOp
//                print("created a dictionary entry for id \(photoReference.id)")
//            }
            
        }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewUserShowSegue" {
            guard let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { fatalError() }
            detailVC.person = peopleController.people[indexPath.row]
        }
        
    }

}
