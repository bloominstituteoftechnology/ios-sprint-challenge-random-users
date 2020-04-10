//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Karen Rodriguez on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let peopleController = PeopleController()
    let photoFetchQueue = OperationQueue()
    let thumbCache = Cache<UUID, Data>()
    let largeCache = Cache<UUID, Data>()
    private var fetchThumbCache: [UUID : FetchPhotoOperation] = [ : ]
    // Was only going to cache the fetchThumb ops but, just for safety
    private var fetchLargeCache: [UUID : FetchPhotoOperation] = [ : ]

    override func viewDidLoad() {
        super.viewDidLoad()
        peopleController.fetchPeople() { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peopleController.people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PersonTableViewCell else { fatalError() }

        // Configure the cell...
        let person = peopleController.people[indexPath.row]
        cell.nameLabel.text = person.fullName()
        cell.id = person.id
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let person = peopleController.people[indexPath.row]
        fetchThumbCache[person.id]?.cancel()
        fetchLargeCache[person.id]?.cancel()
    }

    
    // MARK: - Methods
    
    private func loadImage(forCell cell: PersonTableViewCell, forItemAt indexPath: IndexPath) {
            
        let person = peopleController.people[indexPath.item]
        
        
        // Changed from checking person.id to cell.id
        if let data = thumbCache.value(for: cell.id!),
            let _ = largeCache.value(for: cell.id!){
            cell.personImage.image = UIImage(data: data)
            return
        }
        
        let fetchThumbOp = FetchPhotoOperation(personReference: person, requestType: .thumbnail)
        let fetchLargeOp = FetchPhotoOperation(personReference: person, requestType: .large)
        fetchLargeOp.addDependency(fetchThumbOp)
        let storeCache = BlockOperation {
            if let thumbData = fetchThumbOp.imageData,
                let largeData = fetchLargeOp.imageData {
                print("Was able to get image data from fetch operation")
                self.thumbCache.cache(value: thumbData, for: person.id)
                self.largeCache.cache(value: largeData, for: person.id)
            } else {
                print("NO DATA TO STORE IN STORECAHCE OP")
            }
        }
        storeCache.addDependency(fetchThumbOp)
        storeCache.addDependency(fetchLargeOp)
            
        let lastOp = BlockOperation {
            print("Last OP called.")
            guard let data = fetchThumbOp.imageData,
                cell.id == person.id else {
                    print("Couldn't cast cell and/or get data")
                    return
                }
            cell.personImage.image = UIImage(data: data)
        }
        lastOp.addDependency(fetchThumbOp)
        lastOp.addDependency(fetchLargeOp)
        photoFetchQueue.addOperations([fetchThumbOp, fetchLargeOp, storeCache], waitUntilFinished: false)
        OperationQueue.main.addOperation(lastOp)
            
            // Given that all other operations depend on fetching thumb, I'll only cancel this operation
            if fetchThumbCache[person.id] == nil,
                fetchLargeCache[person.id] == nil {
                fetchThumbCache[person.id] = fetchThumbOp
                fetchLargeCache[person.id] = fetchLargeOp
                print("created a dictionary entry for id \(person.id)")
            }
            
        }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewUserShowSegue" {
            guard let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { fatalError() }
            let person = peopleController.people[indexPath.row]
            detailVC.person = person
            detailVC.imageData = largeCache.value(for: person.id)
        }
        
    }

}
