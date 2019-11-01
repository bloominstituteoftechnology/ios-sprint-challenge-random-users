//
//  RandomPeopleTableViewController.swift
//  Random Users
//
//  Created by Gi Pyo Kim on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomPeopleTableViewController: UITableViewController {
    
    let randomPersonController = RandomPersonController()
    
    var randomPeople: [Person] = []
    
    var pictureReferences = [Picture]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        randomPersonController.fetchRandomPeople { (randomPerson, error) in
            if let error = error {
                NSLog("Error fetching random people: \(error)")
                return
            }
            
            if let randomPerson = randomPerson {
                let index = randomPerson.results.indices
                var pictureArray: [Picture] = []
                for i in index {
                    pictureArray.append(randomPerson.results[i].picture)
                }
                self.pictureReferences = pictureArray
                self.randomPeople = randomPerson.results
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomPeople.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
    @IBAction func AddButtonTabbed(_ sender: UIBarButtonItem) {
    }
    
}
