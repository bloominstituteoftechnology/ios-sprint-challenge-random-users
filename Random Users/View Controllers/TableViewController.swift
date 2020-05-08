//
//  TableViewController.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        networkController.getUsers {
            DispatchQueue.main.async {
                self.updateViews()
            }
        } //Fetch Users
    }
    
    //MARK: - Properties
    let networkController = NetworkController()
    let cache = Cache<IndexPath, Data>()
    
    //MARK: - Custom Functions
    func updateViews() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController.users?.results.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier , for: indexPath)

        //Get User
        let tempUser = networkController.users?.results[indexPath.row]
        guard let user = tempUser else {
            print("Bad user in \(#function)")
            return cell
        }
        
        //DownCasting Cell
        guard let myCell = cell as? PersonTableViewCell else {
            return cell
        }
        
        loadImage(cell: myCell, indexPath: indexPath) //Assign Cell their Image
        
        //Assigning Properties to Cell
        myCell.nameLabel.text = "\(user.name.first) \(user.name.last)"
        
        return myCell
    }
    
    //Loads Image Using NetworkController Methods and Stores them in the Cache for later use
    func loadImage(cell: PersonTableViewCell, indexPath: IndexPath) {
        
        //Unwrap User
        let tempUser = networkController.users?.results[indexPath.row]
        guard let user = tempUser else {
            print("Bad user in \(#function)")
            return
        }
    
        //Image wasn't stored
        if cache.value(for: indexPath) == nil {
            //Load Image
            networkController.fetchImage(imageURL: URL(string: user.picture.thumbnail), indexPath: indexPath, cache: cache) {
                DispatchQueue.main.async {
                    
                    guard let imageData = self.cache.value(for: indexPath) else {
                        print("Bad imageData in \(#function)")
                        return
                    }
                    
                    let image = UIImage(data: imageData)
                    cell.imageView?.image = image
                }
            }
        } else {
            //We already have the image stored
            guard let imageData = self.cache.value(for: indexPath) else {
                print("Bad imageData in \(#function)")
                return
            }
            
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
        }
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
        
        //Go to PersonViewController and assign it a user
        guard let identifier = segue.identifier else {
            print("No identifier \(#function)")
            return
        }
        
        //Selected Cell
        guard let row = tableView.indexPathForSelectedRow?.row else {
            return
        }
        
        let user = networkController.users?.results[row]
        
        //Assign User
        if identifier == PersonViewController.identifier {
            //DownCast
            guard let destination = segue.destination as? PersonViewController else {
                print("Not PersonViewController \(#function)")
                return
            }
            
            destination.user = user
            destination.networkController = networkController
        }
    }
    

}
