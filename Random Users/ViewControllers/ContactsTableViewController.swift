//
//  ContactsTableViewController.swift
//  ContactManager
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    // MARK:- Properties
    
    let users = UsersController().getUsers()
    private var cache = Cache<String, UIImage>()
    
    private var operations = [String: Operation]()
    
    private var thumbnailFetchQueue = OperationQueue()
    
    // MARL:- Table View Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func generateUsers(_ sender: Any) {
        tableView.isHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let users = users?.users else {fatalError()}
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? ContactTableViewCell else {fatalError()}

        DispatchQueue.main.async {
            self.updateCell(forCell: cell, forItemAt: indexPath)
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let users = users?.users else {return}
        let user = users[indexPath.row]
        
        guard let operation = operations[user.phone] else {return}
        operation.cancel()

    }
    
    // MARK: - Private Methods
    
    private func updateCell(forCell cell: ContactTableViewCell, forItemAt indexPath: IndexPath){
        
        guard let users = users?.users else {return}
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.name
        
        let fetchOperation = FetchThumbnailOperation(thumbnailURL: user.imageThumbnailURL)
        let cacheOperation = BlockOperation {
            self.cache.cache(value: UIImage(data: fetchOperation.imageData!)!, key: user.phone)
        }
        let setOperation = BlockOperation {
            // ATTEMPTS TO SET FROM CACHE
            if self.cache.value(for: user.phone) != nil {
                cell.userImageView.image = self.cache.value(for: user.phone)
                return
            }
        }
        
        cacheOperation.addDependency(fetchOperation)
        setOperation.addDependency(fetchOperation)
        
        thumbnailFetchQueue.addOperation(fetchOperation)
        thumbnailFetchQueue.addOperation(cacheOperation)
        
        OperationQueue.main.addOperation(setOperation)
        
        operations.updateValue(fetchOperation, forKey: user.phone)
        
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    }
    

}
