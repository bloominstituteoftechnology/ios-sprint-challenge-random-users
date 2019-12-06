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
    var randomPeople = [RandomPerson]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var thumbnailCache = Cache<Int, Data>()
    var detailImageCache = Cache<Int, Data>()
    let imageFetchQueue = OperationQueue()
    var fetchOperations: [Int: FetchImageOp] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        randomPersonController.fetchRandomPeople { (result) in
            if let result = result {
                self.randomPeople = result
                print("\(result.count) people have been set")
            } else {
                print("Data returned was nil")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        
        cell.randomPerson = randomPeople[indexPath.row]
        loadImage(imageType: .thumbnail, forItemAt: indexPath) { (result) in
            if let result = result {
                cell.thumbNailImageView.image = UIImage(data: result)
            } else {
                print("Image result was nil")
            }
        }
        
        return cell
    }
    
    enum imageType {
        case thumbnail
        case detail
    }
    
    func loadImage(imageType: imageType, forItemAt indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        
        let person = randomPeople[indexPath.row]
        
        if imageType == .thumbnail {
            if let imageData = thumbnailCache.value(for: indexPath.row) {
                completion(imageData)
            } else {
                let fetchImageOperation = FetchImageOp(pic: URL(string: person.picture.thumbnail)!)
                
                let saveToCacheOperation = BlockOperation {
                    guard let data = fetchImageOperation.imageData else {
                        completion(nil)
                        return
                    }
                    self.thumbnailCache.cache(value: data, for: indexPath.row)
                }
                
                let setImageOperation = BlockOperation {
                    guard let imageData = fetchImageOperation.imageData else {
                        completion(nil)
                        return
                    }
                    completion(imageData)
                }
                
                saveToCacheOperation.addDependency(fetchImageOperation)
                setImageOperation.addDependency(fetchImageOperation)
                
                imageFetchQueue.addOperations([fetchImageOperation, saveToCacheOperation], waitUntilFinished: false)
                OperationQueue.main.addOperations([setImageOperation], waitUntilFinished: false)
                
                fetchOperations[indexPath.row] = fetchImageOperation
            }
        } else {
            if let imageData = detailImageCache.value(for: indexPath.row) {
                completion(imageData)
            } else {
                let fetchImageOperation = FetchImageOp(pic: URL(string: person.picture.large)!)
                
                let saveToCacheOperation = BlockOperation {
                    guard let data = fetchImageOperation.imageData else {
                        completion(nil)
                        return
                    }
                    self.detailImageCache.cache(value: data, for: indexPath.row)
                    completion(data)
                }
                
                saveToCacheOperation.addDependency(fetchImageOperation)
                
                imageFetchQueue.addOperations([fetchImageOperation, saveToCacheOperation], waitUntilFinished: true)
                
                fetchOperations[indexPath.row] = fetchImageOperation
            }
        }
    }

   
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailVC = segue.destination as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                detailVC.person = self.randomPeople[indexPath.row]
                loadImage(imageType: .detail, forItemAt: indexPath) { (data) in
                    if let imageData = data {
                        detailVC.imageData = imageData
                    } else {
                        print("problem")
                    }
                }
            }
        }
    }
}
