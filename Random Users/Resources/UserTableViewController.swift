//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_268 on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    let userController = UserController()
    var cache = Cache<String, Data>()
    var toBeFetched = [String : FetchImageOperation]()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.fetchUsers {
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Methods
    func fetchImage(for cell: UserTableViewCell, at indexPath: IndexPath) {
        // String of thumbnail URL
        let thumb = String(describing: userController.users[indexPath.row].thumbnail)
        // if cache contains that URL already, recache and then set cell thumbnailIV to a new image
        if cache.value(for: thumb) != nil {
            let imageData = cache.value(for: thumb)!
            self.cache.cache(value: imageData, for: thumb)
            cell.thumbnailIV.image = UIImage(data: imageData)
            return
        }
        
        // fetch image OP
        let fetchImageOperation = FetchImageOperation(imageURL: thumb)
        
        // First action
        DispatchQueue.main.sync {
            if let imageData = fetchImageOperation.imageData {
                self.cache.cache(value: imageData, for: thumb)
            }
        }
        // Second action
        DispatchQueue.main.async {
            defer { self.toBeFetched.removeValue(forKey: self.userController.users[indexPath.row].name) }
            // Same as line 25, kinda
            if self.tableView.indexPath(for: cell) != indexPath {
                return
            } else {
                guard let imageData = fetchImageOperation.imageData else { return }
                cell.thumbnailIV.image = UIImage(data: imageData)
            }
        }
        // add op to list
        toBeFetched[userController.users[indexPath.row].name] = fetchImageOperation
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        cell.nameLabel.text = userController.users[indexPath.row].name
        fetchImage(for: cell, at: indexPath)
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailVC = UserDetailViewController(nibName: nil, bundle: nil)
        userDetailVC.nameTV.text = userController.users[indexPath.row].name
        userDetailVC.userImage.image = UIImage(data: cache.value(for: String(describing: userController.users[indexPath.row].large))!)
        userDetailVC.addressTV.text = userController.users[indexPath.row].location
        userDetailVC.phoneNumberTV.text = userController.users[indexPath.row].number
        navigationController?.show(userDetailVC, sender: UserTableViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        toBeFetched[userController.users[indexPath.row].name]?.cancel()
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
