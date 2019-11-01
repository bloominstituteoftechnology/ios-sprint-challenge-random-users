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
    var thumbnailCache = Cache<UUID, Data>()
    var largeImageCache = Cache<IndexPath, Data>()
    var fetchOperations: [UUID: FetchPictureOperation] = [:]
    var pictureFetchQueue = OperationQueue()
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomPersonCell", for: indexPath) as? RandomPersonTableViewCell ?? RandomPersonTableViewCell()
        
        loadImage(forCell: cell, forItemAt: indexPath)
        cell.name = randomPeople[indexPath.row].name

        return cell
    }
    
    
    private func loadImage(forCell cell: RandomPersonTableViewCell, forItemAt indexPath: IndexPath) {
        var pictureReference = pictureReferences[indexPath.row]
        
        let fetchPictureOperation = FetchPictureOperation(pictureReference: pictureReference)
        
        let id = pictureReference.id ?? UUID()
        pictureReference.id = id
        
        if let imageData = thumbnailCache.value(for: id) {
            let image = UIImage(data: imageData)
            cell.personImageView.image = image
            return
        }

        let cacheImageOperation = BlockOperation {
            guard let imageData = fetchPictureOperation.thumbnailData, let largeImageData = fetchPictureOperation.largeData else { return }
            self.thumbnailCache.cache(value: imageData, for: id)
            self.largeImageCache.cache(value: largeImageData, for: indexPath)
        }
        
        let setImageOperation = BlockOperation {
            if let imageData = fetchPictureOperation.thumbnailData {
                if self.tableView.indexPath(for: cell) != indexPath {
                    NSLog("Cell has been resued before image loaded")
                    return
                }
                
                defer {
                    self.fetchOperations.removeValue(forKey: pictureReference.id!)
                }
                
                cell.personImageView.image = UIImage(data: imageData)
            }
        }
        
        cacheImageOperation.addDependency(fetchPictureOperation)
        setImageOperation.addDependency(fetchPictureOperation)
        pictureFetchQueue.addOperations([fetchPictureOperation, cacheImageOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(setImageOperation)
        fetchOperations[pictureReference.id!] = fetchPictureOperation
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailVC = segue.destination as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                let person = randomPeople[indexPath.row]
                detailVC.imageData = largeImageCache.value(for: indexPath)
                detailVC.name = person.name
                detailVC.person = person
            }
        }
        
    }
    
    
    
    @IBAction func AddButtonTabbed(_ sender: UIBarButtonItem) {
    }
    
}
