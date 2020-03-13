//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Ufuk Türközü on 13.03.20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    let userController = UserController()

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.fetchUsers { error in
            if let error = error {
                NSLog("Error loading user list: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.userList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        // Configure the cell...
        let user = userController.userList[indexPath.row]
        cell.textLabel?.text = user.name
        guard let picture = try? Data(contentsOf: user.picture) else { return UITableViewCell() }
        cell.imageView?.image = UIImage(data: picture)

        return cell
    }
    
//    private func loadImage(forCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        let photoReference = photoReferences[indexPath.row]
//
//        if let cData = photoCache.value(for: photoReference.id) {
//            DispatchQueue.main.async {
//                guard let image = UIImage(data: cData) else { return }
//            }
//        }
//
//        guard let url = photoReference.imageURL.usingHTTPS else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//
//            if let error = error {
//                NSLog("Error: \(error)")
//            }
//
//            guard let data = data else {
//                NSLog("Error loading Image")
//                return
//            }
//
//            guard let image = UIImage(data: data) else { return }
//
//            DispatchQueue.main.async {
//                let newIndex = self.collectionView.indexPathsForVisibleItems
//                if newIndex.contains(indexPath) {
//                    cell.imageView.image = image
//                }
//            }
//
//        }.resume()
//
//        // TODO: Implement image loading here
//    }

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
        if segue.identifier == "ShowUserDetailSegue" {
            guard let detailVC = segue.destination as? UserDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = userController.userList[indexPath.row]
            detailVC.user = user
        }
    }
}
