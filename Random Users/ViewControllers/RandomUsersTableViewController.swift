//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController
{
    var userController = UserController()
    var users: [User] = []
    private var cache = Cache<String, User>()
    private var userFetchOperations: [String : UserFetchOperation] = [:]
    private let userFetchQueue: OperationQueue = OperationQueue.main
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userController.getUsers { (users, error) in
            if let error = error
            {
                NSLog("error fetching users: \(error)")
                return
            }
            
            guard let users = users else {return}
            
            DispatchQueue.main.async {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)

        let user = users[indexPath.row]
        
        let fetchOperation = userFetchOperations[user.identifier]
        fetchOperation?.cancel()
        

        return cell
    }
    
    private func loadUser(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath)
    {
        let user = users[indexPath.row]
        
        if let cached = cache.value(for: user.identifier)
        {
            DispatchQueue.main.async {
                cell.textLabel?.text = cached.name
                
                //cell.imageView?.image = UIImage(data: user.thumbnail)
                
                return
            }
            
        }
        
        let operationQueue = OperationQueue()
        operationQueue.name = "com.leastudios.RandomUsers.Queue"
        let operation1 = BlockOperation
        {
            self.cache.cache(for: user.identifier, with: user)
        }
        
        let operation2 = BlockOperation
        {
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath
            {
                return
            }
            
            
            cell.textLabel?.text = user.name
        }
        
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        userFetchQueue.cancelAllOperations()
    }
    
    // MARK: - Navigation
     //ShowDetail
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
///////end
}
