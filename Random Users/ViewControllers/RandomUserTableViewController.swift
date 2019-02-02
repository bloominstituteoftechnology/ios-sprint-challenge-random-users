//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        randomUserController.getRandomUsers {_ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let cache = Cache<String, Data>()
    var randomUserController = RandomUserController()
    private var userFetchQueue = OperationQueue()
    private var allOperations: [Int : FetchPhotoOperation] = [:]
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! RandomUserTableViewCell
        
        loadImage(forCell: cell, forItemAt: indexPath)
//        let userReference = randomUserController.users[indexPath.row].results[indexPath.row]
//        let userFirstName = userReference.name.first
//        let userLastName = userReference.name.last
//                //cell.userThumbnailImage.image = UIImage(data: <#T##Data#>)
//                cell.userNameLabel.text = "\(userFirstName) \(userLastName)"
//
//                print("\(userFirstName) \(userLastName)")
        
      // loadImage(forCell: cell, forItemAt: indexPath)
        
       // let user = randomUserController.users[indexPath.row] //randomUserController.users[indexPath.row].results[indexPath.row]
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
        
       // let userLastName = user.name.last
        //cell.userThumbnailImage.image = UIImage(data: <#T##Data#>)
        let user = randomUserController.users[indexPath.row]
        let userFirstName = user.first.capitalized
        let userLastName = user.last.capitalized
        let userTitle = user.title.capitalized
        cell.userNameLabel.text = "\(userTitle) \(userFirstName) \(userLastName)"

        return cell
    }
    
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = randomUserController.users[indexPath.row]
        let userPhone = userReference.phoneNumber
        guard let userImageURL = userReference.thumbnailImageURL?.usingHTTPS else { return }
        
        
        
       if let value = cache.value(forKey: userPhone) {
        
            cell.imageView?.image = UIImage(data: value)
        } else {
        
        
            URLSession.shared.dataTask(with: userImageURL) { (data, _, error) in

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
           // detailDVC.randomUser = result?.results[index.row]
        }
    }
    
   
}
