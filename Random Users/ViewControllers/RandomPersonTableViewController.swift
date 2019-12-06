//
//  RandomPersonTableViewController.swift
//  Random Users
//
//  Created by Dennis Rudolph on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomPersonTableViewController: UITableViewController {
    
    var randomPersonController = RandomPersonController()
    var randomPeople = [RandomPerson]()
    var thumbnailCache = Cache<Int, Data>()
    var largeImageCache = Cache<Int, Data>()
    let imageFetchQueue = OperationQueue()
//    var fetchOperations: [Int: FetchImageOp] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        randomPersonController.fetchRandomPeople { (result) in
            if let result = result {
                self.randomPeople = result
            } else {
                print("Data returned was nil")
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomPeople.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        
        cell.randomPerson = randomPeople[indexPath.row]
        //.loadImage

        return cell
    }
    
    func loadImage() {
        
    }

   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}
