//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Joe on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {
    
    var apiController = APIController()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
            updateViews()
        }
        
    func updateViews() {
        //To call or execute function after some time and update UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.apiController.getRandomUsers() {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async(execute: {
                //Update UI
                self.tableView.reloadData()
            })
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return apiController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUserCell", for: indexPath)
        
        let user = apiController.users[indexPath.row]

        let image = displayURLImage(url: user.picture.thumbnail)
        let name = "\(user.name.title) \(user.name.first) \(user.name.last)"
        cell.textLabel?.text = name
        cell.imageView?.image = image
    
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

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
        if segue.identifier == "ToDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? UserDetailViewController else { return }
            detailVC.personDelegate = apiController.users[indexPath.row]
        } else if segue.identifier == "AddNew" {
            let addVC = segue.destination as? UserDetailViewController
        }

    }
    


}
