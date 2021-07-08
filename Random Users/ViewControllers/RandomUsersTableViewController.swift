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
    var userImage: Data?
    private var cache = Cache<String, User>()
    var userFetch = UserFetchOperation()
    private var imageFetchOperations: ImageFetchOperation?
    private var userFetchOperation: UserFetchOperation?
    var picture: Picture?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userController.getUsers { (users, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            
            guard let users = users else {
                NSLog("Error loading users")
                return
            }
            
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

        //loadUser(forCell: cell, forItemAt: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = (user.name?.firstName)! + " " + (user.name?.lastName)!
        if let image = imageFetchOperations?.thumbnail {
            cell.imageView?.image = image
        }
        
        
        return cell
    }
    
    private func loadUser(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath)
    {
//        let user = users[indexPath.row]
////
//        if let cached = cache.value(for: user.identifier)
//        {
//            DispatchQueue.main.async {
//
//
//                if let picture = cache.url
//                {
//                    self.userImage = picture
//                    cell.imageView?.image = UIImage(data: picture)
//                }
//
//
//                return
//            }
//
//        }
//
//        let operationQueue = OperationQueue()
//        operationQueue.name = "com.leastudios.RandomUsers.Queue"
//        let operation1 = BlockOperation
//        {
//            self.cache.cache(for: user.identifier, with: user)
//        }
//
//        let operation2 = BlockOperation
//        {
//            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath
//            {
//                return
//            }
//
//
//            cell.textLabel?.text = user.name
//        }
//
//        operationQueue.addOperations([operation1, operation2], waitUntilFinished: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        userFetchOperation?.cancel()
    }
    
    // MARK: - Navigation
     //ShowDetail
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowDetail"
        {
            let detailVC = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            detailVC.user = user
            
            if let image = userImage {
                detailVC.userImage = image
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
///////end
}
