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
    
    enum SortTypes {
        case first
        case last
    }
    
    //=======================
    // MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //=======================
    // MARK: - IBActions
    @IBAction func sortOrderChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.sortType = .first
            sortUsers()
            tableView.reloadData()
        case 1:
            self.sortType = .last
            sortUsers()
            tableView.reloadData()
        default:
            print("error with segmented control - invalid index")
        }
    }
    
    //=======================
    // MARK: - Properties
    var users : [User]?
    private let queue = OperationQueue()
    private let cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    private var sortType: SortTypes = .first
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    //=======================
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userCell.rawValue) as? UserTableViewCell else { return UITableViewCell() }
        cell.user = users?[indexPath.row]
        fetchThumbnailImageAndSet(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    //=======================
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users?[indexPath.row]
        operations[user?.email ?? "No email given"]?.cancel()
    }
    
    //=======================
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.userDetail.rawValue {
            guard let destination = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
            else { return }
            let user = users?[indexPath.row]
            destination.user = user
            destination.delegate = self
            destination.imageData = cache.value(for: user?.phone ?? "")
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
                    self.users = userResults.results.sorted {$0.fname < $1.fname}
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    func fetchThumbnailImageAndSet(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row] else { return }
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
    
    func sortUsers() {
        switch sortType {
        case .first:
            users = users?.sorted {$0.fname < $1.fname}
        case .last:
            users = users?.sorted {$0.lname < $1.lname}
        }
    }
}
