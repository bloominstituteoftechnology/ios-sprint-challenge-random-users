//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewController: UITableViewController {

    
     override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.reloadData()
        randomUserController.getRandomUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    @IBAction func beginRefresh(_ sender: UIRefreshControl) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.tableView.reloadData()
                sender.endRefreshing()
            
        }
    }
    
    let cache = Cache<String, Data>()
    var randomUserController = RandomUserController()
    private var userFetchQueue = OperationQueue()
    private var allOperations: [String : FetchPhotoOperation] = [:]
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! RandomUserTableViewCell
        
        loadImage(forCell: cell, forItemAt: indexPath)
//
        let user = randomUserController.users[indexPath.row]
        let userFirstName = user.first.capitalized
        let userLastName = user.last.capitalized
        let userTitle = user.title.capitalized
        cell.userNameLabel.text = "\(userTitle) \(userFirstName) \(userLastName)"
        guard let image = try? Data(contentsOf: user.thumbnailImageURL!) else { fatalError("no image") }
        cell.userThumbnailImage.image = UIImage(data: image)
        return cell
    }
    
    private func loadImage(forCell cell: RandomUserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = randomUserController.users[indexPath.row]
        let userIdFirstName = userReference.first
        
       if let value = cache.value(forKey: userIdFirstName) {
        
            cell.userThumbnailImage.image = UIImage(data: value)
        return
        } else {
        
        // operation
        let thumbOperation = FetchPhotoOperation(userReferences: userReference)
        
           
       
        let operationCache = BlockOperation {
            guard let image = thumbOperation.thumbnailImage else { return }
            self.cache.cache(value: image, forKey: userIdFirstName)
        }
        let reuseOperation = BlockOperation {
            guard let image = thumbOperation.thumbnailImage else { return }
            if self.tableView.cellForRow(at: indexPath) == cell {
                cell.userThumbnailImage.image = UIImage(data: image)
            }
        }

        reuseOperation.addDependency(thumbOperation)
        operationCache.addDependency(thumbOperation)

        allOperations[userIdFirstName] = thumbOperation
        userFetchQueue.addOperation(thumbOperation)
        userFetchQueue.addOperation(operationCache)
        OperationQueue.main.addOperation(reuseOperation)


    }
    }
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userReference = randomUserController.users[indexPath.row]

        if let thumbOperation = allOperations[userReference.first] {
            thumbOperation.cancel()
          
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailDVC = segue.destination as! RandomUserDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            detailDVC.randomUser = randomUserController.users[index.row]
        }
    }
    
   
}
