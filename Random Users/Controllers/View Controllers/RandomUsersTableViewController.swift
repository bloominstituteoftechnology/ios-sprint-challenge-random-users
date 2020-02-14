//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Aaron Cleveland on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    let auth = Auth()
    var user = [User]()
    
    let cache = Cache<String, Data>()
    var operations = [String : Operation]()
    let fetchQueue = OperationQueue()
    
    @IBOutlet weak var sortSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth.fetchUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auth.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = auth.users[indexPath.item]
        operations[user.name]?.cancel()
    }
//    customObjects = customObjects.sorted(by: {
//        $0.date.compare($1.date) == .orderedDescending
//    })
//    // The sorted customObjects collection is then printed out to display the objects sorted descending by date
//    for obj in customObjects {
//        print("Sorted Date: \(obj.date) with title: \(obj.title)")
//    }
     
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch sortSegment.selectedSegmentIndex {
        case 0:
            user = user.sorted(by: {
                $0.name < $1.name
            })
        case 1:
            user = user.sorted(by: {
                $0.name > $1.name
            })
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - Helper Function
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = auth.users[indexPath.item]
        
        if let cachedData = cache.value(for: user.name),
            let image = UIImage(data: cachedData) {
            cell.imageView?.image = image
            cell.textLabel?.text = user.name
            return
        }
        
        let fetchUserOperation = FetchContactOperation(user: user)
        let cachedOperation = BlockOperation {
            if let data = fetchUserOperation.imageData {
                self.cache.cache(value: data, for: user.name)
            }
        }
        cachedOperation.addDependency(fetchUserOperation)
        
        let checkOperation = BlockOperation {
            defer { self.operations.removeValue(forKey: user.name) }
            
            if let activeIndexPath = self.tableView?.indexPath(for: cell),
                activeIndexPath != indexPath {
                return
            }
            
            if let imageData = fetchUserOperation.imageData {
                cell.imageView?.image = UIImage(data: imageData)
                cell.textLabel?.text = user.name
            }
        }
        checkOperation.addDependency(fetchUserOperation)
        fetchQueue.addOperation(fetchUserOperation)
        fetchQueue.addOperation(cachedOperation)
        OperationQueue.main.addOperation(checkOperation)
        self.operations[user.name] = fetchUserOperation
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            guard let userDetailVC = segue.destination as? UserDetailViewController,
                let indexPath = self.tableView.indexPathForSelectedRow else { return }
            userDetailVC.user = auth.users[indexPath.row]
        }
    }
}

