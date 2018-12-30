//
//  UserListController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

//Globals
var manager = UserManager()
let importer = UserImporter()


class UserListController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        importer.managerRef = manager
        importer.getUsers {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    } //End of ViewDidLoad
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return manager.addressbook.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! UserCellController
        
            manager.loadImages(path: indexPath)
        
        cell.firstName.text = manager.addressbook[indexPath.row].name.first
        
        cell.surName.text = manager.addressbook[indexPath.row].name.last
        
        cell.imageView?.image = manager.thumbnails[indexPath.row]
        
        cell.heightAnchor.constraint(equalToConstant: 60.0)
        
        return cell
    }
    
    
    //Pass selected cell information via segue to detail view as index path
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" { let detailVC = segue.destination as! UserDetailController
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return } //Unwrap the index path and make it easy to access in the Detail View
            detailVC.currentUser = indexPath
        }
    }
}
