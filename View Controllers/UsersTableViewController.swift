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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

                let user = userController.user[indexPath.row]
                cell.textLabel?.text = user.name.first.capitalized + " " + user.name.last.capitalized
                
                guard let imageData = try? Data(contentsOf: user.picture.thumbnail) else {fatalError()}
                cell.imageView?.image = UIImage(data: imageData)

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
}
