//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Elizabeth Wingate on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       userController.getUsers(completion: { (error) in
        if let error = error {
            print(error)
        }
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
    })
  }

     let photoFetchQueue = OperationQueue()
     let cache = Cache<String, Data>()
    
    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        userController.addUsers = true
        userController.getUsers(completion: { (error) in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
            self.tableView.reloadData()
          }
      })
   }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0 {
             return 60
         } else {
             return 60
         }
     }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let name: String = (user.name["first"]!) + " " + (user.name["last"]!)
        
        if let operation = fetchOperations[name] {
            operation.cancel()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell

        // Configure the cell...
        let user = userController.users[indexPath.row]
        
        cell.user = user
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        let name: String = user.name["first"]!.capitalized + " " + user.name["last"]!.capitalized
        
        cell.nameLabel.text = name

        return cell
    }
    
     var fetchOperations: [String: FetchPhotoOperation] = [:]
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        // TODO: Implement image loading here
        let photoReference = userController.users[indexPath.row]
        let name: String = (photoReference.name["first"]!) + " " + (photoReference.name["last"]!)
        
        if let cacheImage = cache.valueSmall(for: name){
            
            cell.imageThumbnail.image = UIImage(data: cacheImage)
            
        } else {
            
            let fetchPhotoOp = FetchPhotoOperation(user: photoReference)
            
            fetchOperations[name] = fetchPhotoOp
            
            let storeDataOp = BlockOperation {
                guard let data = fetchPhotoOp.imageData else { return }
                self.cache.cacheSmall(value: data, for: name)
            }
            
            let reuseOp = BlockOperation {
                guard let currentIndex = self.tableView.indexPath(for: cell), let data = fetchPhotoOp.imageData else { return }
                
                
                if currentIndex == indexPath {
                    
                    cell.imageThumbnail.image = UIImage(data: data)
                    
                } else {
                    return
                }
            }
            
            storeDataOp.addDependency(fetchPhotoOp)
            reuseOp.addDependency(fetchPhotoOp)
            
            photoFetchQueue.addOperation(fetchPhotoOp)
            photoFetchQueue.addOperation(storeDataOp)
            OperationQueue.main.addOperation(reuseOp)
      }
}
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetail" {
        guard let cellDetailController = segue.destination as? UserDetailViewController, let cell = sender as? UserTableViewCell else { return }
             
          cellDetailController.userController = userController
          cellDetailController.user = cell.user
        }
    }
}
