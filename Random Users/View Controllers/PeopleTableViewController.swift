//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Alex Rhodes on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    let client = PersonController()
    let personPhotoFetchQueue = OperationQueue()
    var operations = [String: Operation]()
    let cache = Cache<String, Data>()
    
   
    
    var peopleDummy: People?
    
    private var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.fetch { (people, error) in
            guard let people = people else {return}
            self.people = people.results
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }
    
   
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else {return UITableViewCell()}
     
        loadImage(forCell: cell, forItemAt: indexPath)
        
        DispatchQueue.main.async {
        
            cell.nameLabel.text = self.people[indexPath.row].name.first
        }
     return cell
     }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        operations[person.name.first]?.cancel()
    }
 
   
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonDetailSegue" {
            guard let destination = segue.destination as? PersonDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            destination.person = people[indexPath.row]
        }
    
     }
     
     private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        
        let person = people[indexPath.row]
        
        if let cacheData = cache.value(key: person.name.first),
            let image = UIImage(data: cacheData) {
            cell.imageView?.image = image
            return
        }
        
        let fetchOp = FetchPeoplePhotoOperation(person: person)
        
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.add(value: data, key: person.name.first)
            }
        }
        
        let completionOp = BlockOperation {
            defer {self.operations.removeValue(forKey: person.name.first)}
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("got image for cell")
                return
            }
            
            if let data = fetchOp.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        completionOp.addDependency(fetchOp)
        cacheOp.addDependency(fetchOp)
        personPhotoFetchQueue.addOperation(fetchOp)
        personPhotoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[person.name.first] = fetchOp
    }
}
