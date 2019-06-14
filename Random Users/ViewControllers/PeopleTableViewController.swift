//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Kobe McKee on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    let personController = PersonController()
    
    var cache = Cache<String, Data>()
    var imageFetchQueue = OperationQueue()
    var imageFetchOperations: [String : FetchThumbnailOperation] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        personController.fetchPeople { (error) in
            if let error = error {
                NSLog("Error fetching people for tableView: \(error)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonTableViewCell

        let person = personController.people[indexPath.row]
        cell.nameLabel.text = person.name
        loadThumbnail(person: person, cell: cell, indexPath: indexPath)

        return cell
    }
    

 

    
    func loadThumbnail(person: Person, cell: PersonTableViewCell, indexPath: IndexPath) {
        
        if let cachedImage = cache.value(key: person.email) {
            cell.thumbnailImageView.image = UIImage(data: cachedImage)
            return
        }
        
        let fetchOp = FetchThumbnailOperation(person: person)
        let cacheOp = BlockOperation {
            if let data = fetchOp.thumbnailData {
                self.cache.cache(value: data, key: person.email)
            }
        }
        
        let checkReuseOp = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            if let data = fetchOp.thumbnailData {
                cell.thumbnailImageView.image = UIImage(data: data)
            }
        }
        
        cacheOp.addDependency(fetchOp)
        checkReuseOp.addDependency(fetchOp)
        
        imageFetchQueue.addOperation(fetchOp)
        imageFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(checkReuseOp)
        
        imageFetchOperations[person.email] = fetchOp
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
