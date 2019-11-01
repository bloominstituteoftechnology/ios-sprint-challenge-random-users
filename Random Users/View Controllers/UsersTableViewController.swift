//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Isaac Lyons on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    private var userController = UserController()
    private let thumbnailCache = Cache<Int, UIImage>()
    private let largePictureCache = Cache<Int, UIImage>()
    private let photoFetchQueue = OperationQueue()
    private var fetchOperations: [Int: FetchPhotoOperation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.fetchUsers { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        cell.textLabel?.text = userController.users[indexPath.row].name
        loadImage(forItemAt: indexPath, sized: .thumbnail, cache: thumbnailCache) { (image) in
            if self.tableView.indexPath(for: cell) == indexPath {
                cell.imageView?.image = image
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchOperations[indexPath.row]?.cancel()
    }
    
    //MARK: Private
    
    private func loadImage(forItemAt indexPath: IndexPath, sized imageSize: User.UserKeys.PictureKeys, cache: Cache<Int, UIImage>, completion: @escaping (UIImage?) -> Void) {
        let user = userController.users[indexPath.row]
        let photoReference: URL
        
        switch imageSize {
        case .thumbnail:
            print("Thumbnail")
            photoReference = user.thumbnailURL
        case .medium:
            photoReference = user.mediumPictureURL
        case .large:
            print("Large photo")
            photoReference = user.largePictureURL
        }
        print(photoReference)
        
        if let image = cache.value(for: indexPath.row) {
            completion(image)
        } else {
            let fetchOperation = FetchPhotoOperation(reference: photoReference)
            
            let saveToCache = BlockOperation {
                guard let image = UIImage(data: fetchOperation.imageData ?? Data()) else {
                    completion(nil)
                    return
                }
                cache.cache(value: image, for: indexPath.row)
            }
            
            let setImage = BlockOperation {
                guard let image = UIImage(data: fetchOperation.imageData ?? Data()) else {
                    completion(nil)
                    return
                }
                
                completion(image)
            }
            
            saveToCache.addDependency(fetchOperation)
            setImage.addDependency(fetchOperation)
            
            photoFetchQueue.addOperations([fetchOperation, saveToCache], waitUntilFinished: false)
            OperationQueue.main.addOperations([setImage], waitUntilFinished: false)
            
            fetchOperations[indexPath.row] = fetchOperation
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userDetailVC = segue.destination as? UserDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            userDetailVC.user = userController.users[indexPath.row]
            
            loadImage(forItemAt: indexPath, sized: .large, cache: largePictureCache) { (image) in
                userDetailVC.image = image
            }
        }
    }

}
