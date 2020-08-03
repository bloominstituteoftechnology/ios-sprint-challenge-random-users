//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_241 on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    let userController = UserController()
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        
    }
    
    
    
    private func fetchUsers() {
        
        userController.fetchUser { (result, error) in
            
            DispatchQueue.main.async {
                self.user = result
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadImage(for result: Result, for cell: UITableViewCell , forItemAt indexPath: IndexPath) {
        
        ImageDownloadManager.shared.downloadImage(result.picture.medium, indexPath: indexPath) { (image, url, _, _) in
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user?.results.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        guard let res = user?.results[indexPath.row] else { return UITableViewCell()
            
        }
        
        let firstName = res.name.first
        let lastName = res.name.last
        cell.textLabel?.text = (firstName ?? "No first Name") + (lastName ?? "No last name")
        
        
        
        
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageURL = user?.results[indexPath.row] { // URL
            loadImage(for: imageURL, for: cell, forItemAt: indexPath)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        ImageDownloadManager.shared.cancelAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserSegue" {
            if let personDetailViewController = segue.destination as? UsersDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                guard let result = user?.results[indexPath.row] else { return }
                
                personDetailViewController.result = result
                if let selectedCell = tableView.cellForRow(at: indexPath)?.imageView?.image {
                    
                    personDetailViewController.image = selectedCell
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
        }
    }
}
