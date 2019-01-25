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
        
        client.getRandomUser()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(client.cache.count)
        return client.cache.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RandomContactCell", for: indexPath) as? RandomContactsTableViewCell else {fatalError("failed to deque cell as random contacts TVCell")}
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        guard let user = client.cache.value(for: indexPath.row) else {fatalError("no user for indexPath")}
        
        cell.contactNameLabel.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        self.performSegue(withIdentifier: "ContactDetailSegue", sender: cell)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userReference = userReferences[indexPath.row]
        
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
//        guard let cell = sender as? RandomContactsTableViewCell else { fatalError("Sender for segue was not a RandomContactsTableViewCell")}
        
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Couldn't get index path")}

        let destVC = segue.destination as! ContactDetailViewController
        guard let user = client.cache.value(for: indexPath.row) else { fatalError("Couldn't get user for that table view row")}
        
        destVC.user = user
        
        let photoString = user.picture.large
        destVC.contactImageView.image = UIImage(contentsOfFile: photoString)
    }
    
    // MARK: - Private
    
    private func loadImage(forCell cell: RandomContactsTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = userReferences[indexPath.item]
        guard let user = client.cache.value(for: indexPath.row) else { return }
        
//        if let imageString = user.picture.thumbnail {
//            let image = UIImage(string: imageString)
//            cell.imageView.image = image
//            return
//        }
//
//        let fetchPhotoOperation = FetchPhotoOperation(userReference: userReference)
//        guard let image = fetchPhotoOperation.image else { return }
//        let cachePhotoOperation = BlockOperation {
//            self.client.cache.cache(value: image, for: userReference.id)
//        }
//
//        let updateUIOpteration = BlockOperation {
//            if let image  = fetchPhotoOperation.image {
//                cell.contactImageView.image = image
//            }
//        }
//        
//        cachePhotoOperation.addDependency(fetchPhotoOperation)
//        updateUIOpteration.addDependency(fetchPhotoOperation)
//        
//        fetchOperations[indexPath.row] = fetchPhotoOperation
//        
//        photoFetchQueue.addOperation(fetchPhotoOperation)
//        photoFetchQueue.addOperation(cachePhotoOperation)
//        OperationQueue.main.addOperation(updateUIOpteration)
//        
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
}
