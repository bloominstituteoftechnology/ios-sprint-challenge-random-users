//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Andrew Liao on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserClient.shared.fetchUserData { (userData) in
            self.userData = userData
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = userData[indexPath.row].fullName
        return cell
    }
    
    func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath){
        let user = userData[indexPath.row]
        
        if let image = cache.value(for: user.fullName) {
            cell.imageView?.image = UIImage(data: image)
            
        } else {
            let queue = OperationQueue()
            queue.name = "UserOperationQueue"
            queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
            
            let imageFetchOperation = FetchThumbNailOperation(user: user)
            
            let cacheOperation = BlockOperation(){
                guard let imageData = imageFetchOperation.thumbData else {return}
                self.cache.cache(value: imageData, for: user.fullName)
            }
            let reuseCheckOperation = BlockOperation()
            if indexPath == self.tableView.indexPath(for: cell){
                
            }
        }
        
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUser"{
            guard let destinationVC = segue.destination as? UserDetailViewController,
                let index = tableView.indexPathForSelectedRow?.row else {return}
            
            destinationVC.user = userData[index]
        }
    }
    
    //MARK: Properties
    private let imageFetchQueue = OperationQueue()
    private var cache: Cache<String, Data> = Cache()
    
    var userData = [User](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
