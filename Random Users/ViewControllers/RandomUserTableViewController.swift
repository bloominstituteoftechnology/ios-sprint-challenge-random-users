//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    
     let cache = Cache<String, Data>()
    let randomUserController = RandomUserController()
    var result: RandomUsersModel? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        randomUserController.getRandomUsers { (error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
        }
            DispatchQueue.main.sync {
                
                self.tableView.reloadData()
            }
            
    }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! RandomUserTableViewCell 
        let userReference = randomUserController.users[indexPath.row].results[indexPath.row]
        let userFirstName = userReference.name.first
        let userLastName = userReference.name.last
                //cell.userThumbnailImage.image = UIImage(data: <#T##Data#>)
                cell.userNameLabel.text = "\(userFirstName) \(userLastName)"
        
                print("\(userFirstName) \(userLastName)")
        
      //  loadImage(forCell: cell, forItemAt: indexPath)
        
//        let user = result![indexPath.row]
//
//        let userImageURL = user.picture.thumbnail.usingHTTPS
//
//        URLSession.shared.dataTask(with: userImageURL!) { (data, _, error) in
//
//            if let error = error {
//                NSLog("\(error)")
//                return
//            }
//
//            guard let photoData = data else { return }
//
//         //   self.cache.cache(value: photoData, forKey: photoReference.id)
//
//            let image = UIImage(data: photoData)
//            DispatchQueue.main.async {
//
//                    cell.userThumbnailImage.image = image
//
//            }
//            }.resume()
//
//        let userFirstName = user.name.first
//        let userLastName = user.name.last
//        //cell.userThumbnailImage.image = UIImage(data: <#T##Data#>)
//        cell.userNameLabel.text = "test"    //"\(userFirstName) \(userLastName)"
//
//        print("\(userFirstName) \(userLastName)")
        return cell
    }
    
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = result?.results[indexPath.row]
        
        let userImageURL = userReference?.picture.thumbnail.usingHTTPS
        
        // TODO: Implement image loading here
        
        if let value = cache.value(forKey: (userReference?.phone)!) {
            
            
            let imageData = value
            cell.imageView?.image = UIImage(data: imageData)
        } else {
            
            URLSession.shared.dataTask(with: userImageURL!) { (data, _, error) in
                
                if let error = error {
                    NSLog("\(error)")
                    return
                }
                
                guard let photoData = data else { return }
                
                //   self.cache.cache(value: photoData, forKey: photoReference.id)
                
                let image = UIImage(data: photoData)
                DispatchQueue.main.async {
                    
                    cell.userThumbnailImage.image = image
                    
                }
                }.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailDVC = segue.destination as! RandomUserDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            detailDVC.randomUser = result?.results[index.row]
        }
    }
    
    private var userFetchQueue = OperationQueue()
    private var allOperations: [Int : FetchPhotoOperation] = [:]
}
