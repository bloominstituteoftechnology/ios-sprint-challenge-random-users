//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by admin on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let client = PersonController()
    let personPhotoFetchQueue = OperationQueue()
    var operations = [String: Operation]()
    let cache = Cache<String, Data>()
    
    private var people = [Person]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        client.fetch { (people, error) in
            guard let people = people else { return }
            self.people = people.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        operations[person.name.first]?.cancel()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetail" {
            guard let destination = segue.destination as? UsersDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            destination.person = people[indexPath.row]
        }
    }
    
    private func loadImage(forCell cell: UsersTableViewCell, forItemAt indexPath: IndexPath) {
        
        let person = people[indexPath.row]
        
        if let cacheData = cache.value(key: person.name.first),
            let image = UIImage(data: cacheData) {
            cell.usersImageView.image = image
            return
        }
        
        let fetchOperation = FetchPeoplePhotosOperation(person: person)
        
        let cacheOperation = BlockOperation {
            if let data = fetchOperation.imageData {
                self.cache.add(value: data, key: person.name.first)
            }
        }
        
        let completionOperation = BlockOperation {
            defer { self.operations.removeValue(forKey: person.name.first) }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("got image for cell")
                return
            }
            
            if let data = fetchOperation.imageData {
                cell.usersImageView.image = UIImage(data: data)
                cell.usersNameLabel.text = person.name.first
            }
    
        }
        
        completionOperation.addDependency(fetchOperation)
        cacheOperation.addDependency(fetchOperation)
        personPhotoFetchQueue.addOperation(fetchOperation)
        personPhotoFetchQueue.addOperation(cacheOperation)
        OperationQueue.main.addOperation(completionOperation)
        
        operations[person.name.first] = fetchOperation
        
    }
}
