//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Dillon P on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    private var people: [Person] = []
    private let fetchImageQueue = OperationQueue()
    var cache = Cache<String, Data>()
    private var photoReferences = [String]()
    var operationsDictionary = [ String: Operation ]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PeopleController.shared.fetchPeople { (_) in
            
            for people in PeopleController.shared.results {
                let allPeople = people.results
                for person in allPeople {
                    self.people.append(person)
                    self.photoReferences.append(person.pictureURL)
                }
            }
            
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        
        let person = people[indexPath.row]
        cell.nameLabel.text = person.name
        fetchImage(forCell: cell, forItemAt: indexPath)

        return cell
    }

    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPersonDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let person = people[indexPath.row]
                if let personDetailVC = segue.destination as? PersonDetailViewController {
                    personDetailVC.person = person
                    personDetailVC.cache = cache
                }
            }
        }
    }
    
    
    func fetchImage(forCell cell: PersonTableViewCell, forItemAt indexPath: IndexPath) {
    
        let photoUrlString = photoReferences[indexPath.row]
        let person = people[indexPath.row]
        
        if let cachedData = cache.value(for: photoUrlString) {
            guard let picture = UIImage(data: cachedData) else { return }
            
            DispatchQueue.main.async {
                cell.personImageView.image = picture
            }
        }
        
        // Operations
        
        let fetchOP = FetchImageOperation(person: person)
        
        let cacheOP = BlockOperation {
            guard let data = fetchOP.imageData else { return }
            self.cache.cache(value: data, for: person.pictureURL)
        }
        
        let uiOP = BlockOperation {
            guard let data = fetchOP.imageData else { return }
            
            DispatchQueue.main.async {
                if let newIndices = self.tableView.indexPathsForVisibleRows {
                    if newIndices.contains(indexPath) {
                        let image = UIImage(data: data)!
                            cell.personImageView.image = image
                    }
                }
            }
        }
        
        cacheOP.addDependency(fetchOP)
        uiOP.addDependency(fetchOP)
        
        fetchImageQueue.addOperations([fetchOP, cacheOP, uiOP], waitUntilFinished: false)
        
        operationsDictionary[photoUrlString] = uiOP
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photoUrlString = photoReferences[indexPath.row]
        operationsDictionary[photoUrlString]?.cancel()
    }
    
}


