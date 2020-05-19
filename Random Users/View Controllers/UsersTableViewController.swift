//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Juan M Mariscal on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    private let cache = Cache<Int, UIImage>()
    let userController = UserController()
    var photoReferences = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.fetchUsers { (error) in
            
//                let users = try result.get()
                DispatchQueue.main.async {
//                    self.userController.userList.append(users)
                    self.tableView.reloadData()
                }
            if let error = error {
                    switch error {
                    case .decodeFailed:
                        print("Error: Theee data could not be decoded. \(error)")
                    case .noData:
                        print("Error: The response had no Data.")
                    case .otherError(let otherError):
                        print("Error: \(otherError)")
                    case .noAuth:
                        print("Error: No Auth")
                    case .unauthorized:
                        print("Error: Not Authorized")
                    case .encodedFailed:
                        print("Error: Encoded Failed")
                }
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as? UsersTableViewCell else {
            fatalError("Can't deqeue cell of type 'UsersCell' ")
        }
        
        let user = userController.userList[indexPath.row]
        
        cell.userNameLabel?.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        cell.userImageView.image = UIImage(named: user.picture.thumbnail)
        //loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

//    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
//        let photoReference = photoReferences[indexPath.item]
//
//        guard let photoURL = photoReference.picture.thumbnail else {
//            NSLog("Error getting image URL")
//            return
//        }
//
//        if let cacheImage = cache.value(for: photoReference.id) {
//            cell.userImageView.image = cacheImage
//            return
//        }
//
//        URLSession.shared.dataTask(with: photoURL) { (data, _, error) in
//            if let error = error {
//                NSLog("Error loading image: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                NSLog("Error: No image data returned")
//                return
//            }
//            DispatchQueue.main.async {
//
//                guard self.tableView.indexPath(for: cell) == indexPath else { return }
//                cell.userImageView.image = UIImage(data: data)
//            }
//
//        }.resume()
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserDetailSegue",
//            let detailVC = segue.destination as? UsersDetailViewController,
//            let selectedIndexPath = tableView.indexPathForSelectedRow {
//            detailVC.userController = userController
//            detailVC.
//        }
//    }

}
