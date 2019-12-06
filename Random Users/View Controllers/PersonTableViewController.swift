//
//  PersonTableViewController.swift
//  Random Users
//
//  Created by brian vilchez on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonTableViewController: UITableViewController {

    
    //MARK: - Properties
    private var client = PersonClientAPI()
    var cache: Cache = Cache<String, Data>()
    private var operations = [String: Operation]()
    private let photoFetchQueue = OperationQueue()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        client.fetchRequest { (_) in
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return client.persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell()}
        let person = client.persons[indexPath.row]
        cell.personNameLabel.text = "\(person.firstName) \(person.lastName)"
        loadImage(forCell: cell, forRowAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPersonSegue" {
          guard let indexPath = tableView.indexPathForSelectedRow,
            let personDetailVC = segue.destination as? PersonDetailViewController else { return }
                personDetailVC.person = client.persons[indexPath.row]
        }
    }

     //private
    private func loadImage(forCell cell: PersonTableViewCell, forRowAt indexPath: IndexPath) {


        let person = client.persons[indexPath.row]
        if let cachedData = cache.value(forKey: person.id), let image = UIImage(data: cachedData) {
            cell.personThumbNail.image = image
            return
        }

           // TODO: Implement image loading here
        let fetchOperation = FetchPhotoOperation(photoType: .thumbNail, person: person)
        let cacheOp = BlockOperation {
            if let data = fetchOperation.imageData {
                self.cache.cache(value: data, forKey: person.id)
            }
        }
        
 let completionOp = BlockOperation {
         defer {self.operations.removeValue(forKey: person.id)}
         if let currentIndexpath = self.tableView.indexPath(for: cell),
             currentIndexpath != indexPath {
             print("got image for reused image")
             return
         }
         if let data = fetchOperation.imageData {
             cell.personThumbNail.image = UIImage(data: data)
         }
     }
     
           cacheOp.addDependency(fetchOperation)
           completionOp.addDependency(fetchOperation)
           photoFetchQueue.addOperation(fetchOperation)
           photoFetchQueue.addOperation(cacheOp)
           OperationQueue.main.addOperation(completionOp)
           operations[person.id] = fetchOperation
        }



}
