//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Jonathan Ferrer on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        randomUsersController.fetchUsers { (randomUsers, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
            }
            guard let randomUsers = randomUsers else { return }
            let unOrderedUsers = randomUsers.results
            let alphabetical = unOrderedUsers.sorted()
            self.users = alphabetical
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "Users"
            }
        }
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]

        // uses extension made to capitalize first letter of each name component
        cell.textLabel?.text = "\(user.name.title.capitalizingFirstLetter()) \(user.name.first.capitalizingFirstLetter()) \(user.name.last.capitalizingFirstLetter())"

        loadThumbnailImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]

        let fullName = "\(user.name.title) \(user.name.first) \(user.name.last)"
        let operation = fetchDictionary[fullName]

        operation?.cancel()

    }

    private func loadThumbnailImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        guard let thumbnaillURL = URL(string: user.picture.thumbnail) else { return }
        var imageData: Data?

        let cacheID = user.email
        if let imageData = cache.value(for: cacheID) {
            cell.imageView!.image = UIImage(data: imageData)
            print("Loading from largeImageCache")
        } else {

            let fetchTumbnailOperation = FetchImageOperation(url: thumbnaillURL)

            let getImageDataOperation = BlockOperation {
                imageData = fetchTumbnailOperation.imageData
            }

            let cacheImageOperation = BlockOperation {
                guard let data = imageData else { return }
                self.cache.cache(value: data, for: cacheID)
                print("Caching fetch")
            }

            let setImageOperation = BlockOperation {
                if fetchTumbnailOperation.imageURL?.absoluteString == user.picture.thumbnail {
                    DispatchQueue.main.async {
                        guard let data = imageData else { return }
                        cell.imageView!.image = UIImage(data: data)
                    }
                }
            }

            let thumbnailQueue = OperationQueue()
            getImageDataOperation.addDependency(fetchTumbnailOperation)
            cacheImageOperation.addDependency(getImageDataOperation)
            setImageOperation.addDependency(getImageDataOperation)

            fetchDictionary[cacheID] = fetchTumbnailOperation
            thumbnailQueue.addOperations([fetchTumbnailOperation, getImageDataOperation, cacheImageOperation, setImageOperation], waitUntilFinished: false)
        }
    }



        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowUser" {
                let destinationVC = segue.destination as! UserDetailViewController
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                destinationVC.user = users[indexPath.row]
                destinationVC.largeImageCache = largeImageCache
            }
        }

    var randomUsersController = RandomUsersController()
    var users: [Result] = []
    var cache = Cache<String, Data>()
    var largeImageCache = Cache<String, Data>()
    var fetchDictionary: [String : FetchImageOperation] = [:]



}
