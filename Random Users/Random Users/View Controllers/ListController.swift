//
//  ListController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit

class ListController: UITableViewController {
    
    override func viewDidLoad() {
        
        UserImporter.shared.downloadUsers {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } //Downloading the users
        
    }
    
    
    //Set up Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.shared.contacts.count
    }
    
    //Set up Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! CellController
        
        cell.contactLabel.text = Manager.shared.contacts[indexPath.row].name.first
        
        Manager.shared.loadThumb(for: cell, at: indexPath)
       
        return cell
    }
    
    //Pass data of selected row to detail VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue" {
            
            let detailVC = segue.destination as! DetailController
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC.currentUser = Manager.shared.contacts[indexPath.row]
            
        }
        
    }
    
}






