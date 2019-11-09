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
    let cache = Cache<String, Data>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PeopleController.shared.fetchPeople { (_) in
            
            for results in PeopleController.shared.results {
                let peopleResults = results.results
                for person in peopleResults {
                    self.people.append(person)
                }
            }
            
            DispatchQueue.main.async {
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
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        
        let person = people[indexPath.row]
        cell.nameLabel.text = person.name
        
        let image = fetchImage(forCell: cell, forItemAt: indexPath)
        
        cell.personImageView.image = image

        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) -> UIImage? {
    
        let person = people[indexPath.row]
        var image = UIImage()
        if let defaultImage = "👤".image() {
            image = defaultImage
        }
        
        if let cachedData = cache.value(for: person.pictureURL) {
            guard let picture = UIImage(data: cachedData) else { return image}
            image = picture
        }
        
        // Operations
        
        let fetchOP = FetchImageOperation(person: person)
        
        let cacheOP = BlockOperation {
            guard let data = fetchOP.imageData else { return }
            self.cache.cache(value: data, for: person.pictureURL)
        }
        
        let getImageOP = BlockOperation {
            guard let data = fetchOP.imageData else { return }
            
            
            if let newIndices = self.tableView.indexPathsForVisibleRows {
                if newIndices.contains(indexPath) {
                    image = UIImage(data: data)!
                    
                }
            }
        }
        
        cacheOP.addDependency(fetchOP)
        getImageOP.addDependency(fetchOP)
        
        fetchImageQueue.addOperations([fetchOP, cacheOP], waitUntilFinished: true)
        let mainQueue = OperationQueue.main
        mainQueue.addOperations([getImageOP], waitUntilFinished: false)
        
        return image
    }

}
