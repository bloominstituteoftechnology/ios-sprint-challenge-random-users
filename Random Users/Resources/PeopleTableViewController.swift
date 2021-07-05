//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Vuk Radosavljevic on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        personController.searchForPeople { (error) in
            guard error == nil else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Properties
    let personController = PersonController()
    let imageCache = Cache<String, Data>()
    private var fetchOperationsDictionary = [String:FetchPhotoOperation]()
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personController.people.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PeopleTableViewCell

        let person = personController.people[indexPath.row]
        
        let personsName = person.name
        
        cell.nameLabel.text = personsName["title"]! + " " + personsName["first"]! + " " + personsName["last"]!
        
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let person = personController.people[indexPath.row]
        let personsName = person.name
        let operation = fetchOperationsDictionary[personsName["title"]! + " " + personsName["first"]! + " " + personsName["last"]!]
        operation?.cancel()
    }
    
    
    
    // MARK: - Methods
    private func loadImage(forCell cell: PeopleTableViewCell, forItemAt indexPath: IndexPath) {
        
        
        let person = personController.people[indexPath.row]
        let personsName = person.name
        
        if let imageDataFromCache = imageCache.value(forKey: personsName["title"]! + " " + personsName["first"]! + " " + personsName["last"]!) {
            let image = UIImage(data: imageDataFromCache)
            cell.imageView?.image = image
            return
        }
        
        let photoFetchOperation = FetchPhotoOperation(person: person)
        
        let storeRecievedData = BlockOperation {
            self.imageCache.cache(value: photoFetchOperation.imageData!, forKey: personsName["title"]! + " " + personsName["first"]! + " " + personsName["last"]!)
        }
        
        let checkCellReuse = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                return
            }

            if let data = photoFetchOperation.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        storeRecievedData.addDependency(photoFetchOperation)
        checkCellReuse.addDependency(photoFetchOperation)
        
        let queue = OperationQueue.main
        queue.addOperations([photoFetchOperation, storeRecievedData, checkCellReuse], waitUntilFinished: false)
        
        fetchOperationsDictionary[personsName["title"]! + " " + personsName["first"]! + " " + personsName["last"]!] = photoFetchOperation
  
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PeopleDetailsViewController
        let cell = sender as! PeopleTableViewCell
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        destinationVC.person = personController.people[indexPath.row]
    }

}
