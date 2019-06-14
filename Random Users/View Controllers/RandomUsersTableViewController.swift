//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    let randomUserController = RandomUserController()
    private var cache: Cache<String, UIImage> = Cache()
    private var activeOps: [String: FetchThumbnailOp] = [:]
    private let randomUserFetchQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        randomUserController.fetchRandomUsers { (error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUserController.randomUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        let randomUser = randomUserController.randomUsers[indexPath.row]
        cell.textLabel?.text = randomUser.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let randomUser = randomUserController.randomUsers[indexPath.row]
        activeOps[randomUser.phone]?.cancel()
    }
    
    // MARK: - Image Loading Method
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let detailVC = segue.destination as! RandomUserDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            let randomUser = randomUserController.randomUsers[index.row]
            
            detailVC.randomUserController = randomUserController
            detailVC.randomUser = randomUser
        }
    }
}
