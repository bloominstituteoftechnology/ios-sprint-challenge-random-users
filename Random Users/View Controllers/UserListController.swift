//
//  UserListController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserListController: UITableViewController {
        
    override func viewDidLoad() {
        UserImporter.shared.downloadUsers {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        UserManager.shared.thumbQueue.name = "com.LambdaSchool.RandomUsers.photoQueue"
    }
    
    
    //Set up Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.addressbook.count
    }
    
    //Set up Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCellController
        
        cell.contactLabel.text = UserManager.shared.addressbook[indexPath.row].name.first
        
        UserManager.shared.loadImage(for: cell, at: indexPath)
        if let tempImage = UserManager.shared.cellImage {
            cell.photoThumb.image = tempImage }
        
        return cell
    }
    
    //Pass data of selected row to detail VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            
            let detailVC = segue.destination as! UserDetailController
        
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC.currentUser = UserManager.shared.addressbook[indexPath.row]
            
        }
        
    }
    
}
