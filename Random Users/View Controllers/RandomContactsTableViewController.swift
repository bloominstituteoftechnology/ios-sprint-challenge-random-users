//
//  RandomContactsTableViewController.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomContactsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.fetchAllContent { (results, error) in
            if let error = error {
                NSLog("Error fetching data from server: \(error)")
                return
            }
            guard let results = results else { return }
            for randomUser in results.results {
                self.userReferences.append(randomUser)
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userReferences.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RandomContactCell", for: indexPath) as? RandomContactsTableViewCell else {fatalError("failed to deque cell as random contacts TVCell")}
        
        loadImage(forCell: cell, forItemAt: indexPath)

        let user = userReferences[indexPath.row]
        
        cell.contact = user
        cell.contactNameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        let urlString = user.picture.thumbnail

        if let url = URL(string: urlString) {
            do {
                let imageData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.contactImageView.image = UIImage(data: imageData)
                }
                
            } catch {
                print("Something went wrong loading the image")
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if let fetchPhotoOperation = fetchOperations[indexPath.row] {
            fetchPhotoOperation.cancel()
            print("Cancelled photo operation")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let cell = sender as? RandomContactsTableViewCell else { fatalError("Sender for segue was not a RandomContactsTableViewCell")}
        
        guard let user = cell.contact else { fatalError("Was not able to get random user")}

        let destVC = segue.destination as! ContactDetailViewController
        
        destVC.user = user
    }
    
    // MARK: - Private
    
    private func loadImage(forCell cell: RandomContactsTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = userReferences[indexPath.row]

        if let imageData = cache.value(for: indexPath.row) {
            let image = UIImage(data: imageData)
            cell.contactImageView.image = image
            return
        }
        
        let fetchPhotoOperation = FetchPhotoOperation(user: user)
        
        guard let fetchedPhotoOperationImageData = fetchPhotoOperation.imageData else { return }
        let cachePhotoOperation = BlockOperation {
            self.cache.cache(value: fetchedPhotoOperationImageData, for: indexPath.row)
        }
        
        let updateUIOpteration = BlockOperation {
            if let imageData = fetchPhotoOperation.imageData {
                let image = UIImage(data: imageData)
                cell.contactImageView.image = image
            }
        }
        
        cachePhotoOperation.addDependency(fetchPhotoOperation)
        updateUIOpteration.addDependency(fetchPhotoOperation)
        
        fetchOperations[indexPath.row] = fetchPhotoOperation
        
        photoFetchQueue.addOperation(fetchPhotoOperation)
        photoFetchQueue.addOperation(cachePhotoOperation)
        OperationQueue.main.addOperation(updateUIOpteration)

    }
    
    
    // MARK: - Properties
    private var userReferences = [RandomUser]() {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    private var photoFetchQueue =  OperationQueue()
    private var fetchOperations: [Int: FetchPhotoOperation] = [:]
    private let client = RandomUserClient()
    private var cache = Cache<Int, Data>()
}
