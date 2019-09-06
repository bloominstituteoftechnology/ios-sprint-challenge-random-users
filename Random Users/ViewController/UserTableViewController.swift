//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users: [User] = []
    
    var cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    private var fetchDictionary: [String: Operation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {fatalError("cant make user cell")}
        let user = users[indexPath.row]
        cell.user = user
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let photoFetchOperation = FetchUserPhotoOperation(imageURL: user.thumbnail)
        let saveCacheOperation = BlockOperation {
            self.cache.cache(value: photoFetchOperation.imageData!, for: user.thumbnail)
        }
        let setUpImageViewOperation = BlockOperation {
            DispatchQueue.main.async {
                
                cell.profileImageView.image = UIImage(data: photoFetchOperation.imageData!)
                
            }
        }
        if let imageData = cache.value(for: user.thumbnail) {
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.profileImageView.image = image
                print("loaded cache image")
                return
            }
        }
        
        saveCacheOperation.addDependency(photoFetchOperation)
        setUpImageViewOperation.addDependency(photoFetchOperation)
        photoFetchQueue.addOperations([photoFetchOperation, saveCacheOperation, setUpImageViewOperation], waitUntilFinished: true)
        
        fetchDictionary[user.thumbnail] = photoFetchOperation
    }
    
    func getUsers() {
        let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error getting user: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("no data when getting user")
                return
            }
            //print(String(data: data, encoding: .utf8))
            do {
                let userDict = try JSONDecoder().decode(Results.self, from: data)
                self.users = userDict.results
                
                self.tableView.reloadData()
                //print(self.users)
            } catch {
                NSLog("Error decoding: \(error)")
                return
            }
        }.resume()
    }
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let operation = fetchDictionary[user.thumbnail]
        operation?.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            guard let userVC = segue.destination as? UserDetailViewController, let indexPath = tableView.indexPathForSelectedRow else {fatalError("cant make user vc")}
            userVC.user = users[indexPath.row]
        }
    }
}
