//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Jordan Christensen on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    private let randomUserController = RandomUserController()
    private let cache = Cache<String, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomUserController.fetchResults { (userList, error) in
            if let error = error {
                NSLog("Error fetching random users: \(error)")
                return
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUserController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = randomUserController.users[indexPath.row]
        
        if let image = cache.fetch(key: "thumbnail\(user.id.value)") {
            cell.imageView?.image = image
            return
        }
        
        guard let imageURL = URL(string: user.picture.large) else { return }
        let imageRequest = URLRequest(url: imageURL)
        
        URLSession.shared.dataTask(with: imageRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error. No data returned from given URL")
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                cell.imageView?.image = image
                    
                if let image = image {
                    self.cache.imageDict["thumbnail\(user.id.value)"] = image
                }
            }
        }.resume()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // MARK: - TODO Delete user at indexPath
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailViewSegue" {
            guard let detailVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.user = randomUserController.users[indexPath.row]
            detailVC.cache = cache
        }
    }

}
