//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by John Kouris on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    var personController = PersonController()
    let cache = Cache<String, Data>()
    var operations = [String: Operation]()
    let personFetchQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        personController.getPeople { (error) in
            if let error = error {
                NSLog("Error fetching people info: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personController.people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        self.loadPicture(forCell: cell, forRowAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let personReference = personController.people[indexPath.row]
        operations[personReference.name]?.cancel()
    }
    
    private func loadPicture(forCell cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let personReference = personController.people[indexPath.row]
        
        if let cachedData = self.cache.value(for: personReference.name),
            let picture = UIImage(data: cachedData) {
            cell.imageView?.image = picture
            cell.textLabel?.text = personReference.name
            return
        }
        
        let fetchPersonOp = FetchPersonOperation(person: personReference)
        let cachedOp = BlockOperation {
            if let data = fetchPersonOp.photoData {
                self.cache.cache(value: data, for: personReference.name)
            }
        }
        
        let checkOp = BlockOperation {
            defer { self.operations.removeValue(forKey: personReference.name) }
            
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                
                if let photoData = fetchPersonOp.photoData {
                    cell.imageView?.image = UIImage(data: photoData)
                    cell.textLabel?.text = personReference.name
                }
            }
        }
        
        cachedOp.addDependency(fetchPersonOp)
        checkOp.addDependency(fetchPersonOp)
        
        personFetchQueue.addOperation(fetchPersonOp)
        personFetchQueue.addOperation(cachedOp)
        
        OperationQueue.main.addOperation(checkOp)
        
        self.operations[personReference.name] = fetchPersonOp
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPersonDetailSegue" {
            guard let personDetailVC = segue.destination as? PersonDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            personDetailVC.person = personController.people[indexPath.row]
        }
    }

}
