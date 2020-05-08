//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Hunter Oppel on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let apiController = APIController()
    var cachedItems = Cache<String, UIImage>()
    var fetchOperations = Cache<Int, FetchPhotoOperation>()
    
    let photoFetchQueue = OperationQueue()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        apiController.getUsers { result in
            switch result {
            case .success(_):
                NSLog("Successfully fetched users.")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                NSLog("Failed to fetch users.")
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension UsersTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiController.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell ?? UserTableViewCell()
        
        cell.user = apiController.users[indexPath.row]
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = apiController.users[indexPath.row]
        
        if let image = cachedItems[user.name.first] {
            cell.thumbnailImageView.image = image
            return
        }
        
        let savedIndexPath = indexPath
        
        let fetchPhoto = FetchPhotoOperation(user: user)
        let storeInCache = BlockOperation {
            guard let imageData = fetchPhoto.imageData,
                let image = UIImage(data: imageData) else { return }
            
            self.cachedItems[user.name.first] = image
        }
        let setImageToCell = BlockOperation {
            guard let imageData = fetchPhoto.imageData,
                let image = UIImage(data: imageData),
                savedIndexPath == indexPath else { return }
            
            cell.thumbnailImageView.image = image
        }
        fetchOperations[indexPath.row] = fetchPhoto
        
        storeInCache.addDependency(fetchPhoto)
        setImageToCell.addDependency(fetchPhoto)
                
        photoFetchQueue.addOperations([fetchPhoto, storeInCache], waitUntilFinished: false)
        OperationQueue.main.addOperation(setImageToCell)
    }
}
