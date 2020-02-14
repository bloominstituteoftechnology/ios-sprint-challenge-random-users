//
//  FetchUsersTableViewController.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit
import Foundation

class FetchUsersTableViewController: UITableViewController {
    //=======================
    // MARK: - Types
    enum Identifiers: String {
        case userDetail = "UserDetailViewControllerSegue"
        case userCell = "UserTableViewCell"
    }
    
    //=======================
    // MARK: - Properties
    var users = [User]()
    private let queue = OperationQueue()
    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    //=======================
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userCell.rawValue) as? UserTableViewCell else { return UITableViewCell() }
        cell.user = users[indexPath.row]
        fetchThumbnailImgAndSet(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    //=======================
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        operations[user.email]?.cancel()
    }
    
    //=======================
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.userDetail.rawValue {
            guard let destination = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                users.count >= indexPath.row //could crash since I can't make users an optional
                else { return }
            destination.user = users[indexPath.row]
            destination.delegate = self
            destination.cache = cache
        }
    }
    
    //=======================
    // MARK: - Delegate Methods
    func saveToCache(value: Data, for key: String) {
        cache.cache(value: value, for: key)
    }
    
    //=======================
    // MARK: - Operations
    func fetchUsers() {
        guard let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000") else {return}
        URLSession.shared.dataTask(with: baseUrl) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {return}
            DispatchQueue.main.async {
                do {
                    let userResults = try JSONDecoder().decode(UserResults.self, from: data)
                    let results = userResults.results.sorted {$0.fname < $1.fname}
                    self.users = results
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    func fetchThumbnailImgAndSet(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let imageData = cache.value(for: user.email),
            let image = UIImage(data:imageData) {
            cell.imageView?.image = image
        } else {
            let imageFetchOp = UserImageFetchOperation(user: user)
            imageFetchOp.fetchPhoto(imageType: .thumbnail)
            
            let cacheOp = BlockOperation {
                if let data = imageFetchOp.imageData {
                    self.cache.cache(value: data, for: user.email)
                }
            }
            
            let setImgOp = BlockOperation {
                DispatchQueue.main.async {
                    if let imageData = imageFetchOp.imageData {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
            cacheOp.addDependency(imageFetchOp)
            setImgOp.addDependency(imageFetchOp)
            
            queue.addOperations([
                imageFetchOp,
                cacheOp
            ], waitUntilFinished: false)
            OperationQueue.main.addOperation(setImgOp)
            operations[user.email] = imageFetchOp
        }
    }
}
