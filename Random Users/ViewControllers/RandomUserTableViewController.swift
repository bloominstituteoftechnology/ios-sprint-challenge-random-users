//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    
     let cache = Cache<Int, Data>()
    let randomUserController = RandomUserController()
    var result: [Result]? {
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
        randomUserController.getRandomUsers { (result, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
        }
            self.result = result
    }
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return result?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? RandomUserTableViewCell else { fatalError("no such cell")}
        
        let user = result![indexPath.row]
        
        let userImageURL = user.picture.thumbnail.usingHTTPS
      
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
    
        let userFirstName = user.name.first
        let userLastName = user.name.last
        //cell.userThumbnailImage.image = UIImage(data: <#T##Data#>)
        cell.userNameLabel.text = "test"    //"\(userFirstName) \(userLastName)"

        print("\(userFirstName) \(userLastName)")
        return cell
    }
    
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = result![indexPath.item]
        
        // TODO: Implement image loading here
        
        if let value = cache.value(forKey: userReference.id) {
            
            
            let imageData = value
            cell.imageView.image = UIImage(data: imageData)
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
            detailDVC.randomUser = result![index.row]
        }
    }
    
    private var userFetchQueue = OperationQueue()
    private var allOperations: [Int : FetchPhotoOperation] = [:]
}
