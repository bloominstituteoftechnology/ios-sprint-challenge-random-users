//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Nelson Gonzalez on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var usersController = UsersController()
    
    var cache = Cache<String, Data>()
    var imageFetchQueue = OperationQueue()
    var imageFetchOperations: [URL: FetchImageOperation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    private func fetchUsers() {
        usersController.fetchUsers { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersController.users.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UsersTableViewCell

        let users = usersController.users[indexPath.row]
        
        cell.users = users
        
        fetchUserImages(for: cell, at: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userImage = usersController.users[indexPath.row]
        if let photoImageFetchOperation = imageFetchOperations[URL(string: userImage.thumbnail)!] {
            photoImageFetchOperation.cancel()
        }
    }
   
    
    
    func fetchUserImages(for cell: UsersTableViewCell, at indexPath: IndexPath) {
      
         let photoReference = usersController.users[indexPath.row]
        
         let photoFetchOperation = FetchImageOperation(users: photoReference)
        
        if let imageData = cache.value(for: photoReference.email) {
            let image = UIImage(data: imageData)
            cell.userImageView.image = image
            return
        }
        
       
        let cachePhotoOperation = BlockOperation {
            //put it in a guard cause it was crashing when it was nil
            guard let photoFetchOperationImageData = photoFetchOperation.imageData else {return}
            self.cache.cache(value: photoFetchOperationImageData, for: photoReference.email)
        }
        
        let updateUIImageCellOperation = BlockOperation {
            if let imageData = photoFetchOperation.imageData {
                let image = UIImage(data: imageData)
                cell.userImageView.image = image
            }
        }
        
        cachePhotoOperation.addDependency(photoFetchOperation)
        updateUIImageCellOperation.addDependency(photoFetchOperation)
        
        
        imageFetchOperations[URL(string: photoReference.thumbnail)!] = photoFetchOperation
        
        
        imageFetchQueue.addOperation(photoFetchOperation)
        imageFetchQueue.addOperation(cachePhotoOperation)
        
        OperationQueue.main.addOperation(updateUIImageCellOperation)
        
        
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as? UserDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let users = usersController.users[indexPath.row]
        destinationVC?.users = users
        
    }
   

}
