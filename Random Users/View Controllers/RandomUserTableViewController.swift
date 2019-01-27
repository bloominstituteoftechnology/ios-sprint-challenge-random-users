//
//  RandomUserTableViewController.swift
//  Random Users
//
//  Created by Austin Cole on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

fileprivate let lock = NSLock()

class RandomUserTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomUserController.fetchRandomUsers { (error) -> (Void) in
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
        print(Model.shared.randomUsersCount)
        return Model.shared.randomUsersCount
    }
    var count = 0
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        loadCellContent(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RandomUserDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destination.randomUser = Model.shared.randomUsers?.results[indexPath.row]
    }
    private func loadCellContent(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let randomUserThumbnail = Model.shared.randomUsers?.results[indexPath.row].picture.thumbnail else {return}
        if let data = cache.value(for: (randomUserThumbnail)) {
            cell.imageView?.image = UIImage(data: data)
            cell.textLabel?.text = Model.shared.getName((Model.shared.randomUsers?.results[indexPath.row])!)
        } else {
            let fetchImageOperation = FetchImageOperation()
            fetchImageOperation.indexPath = indexPath
            let cacheAndSetBlockOperation = BlockOperation {
                print(indexPath)
                let data = fetchImageOperation.randomUserThumbnailData
                self.cache.cache(forKey: Model.shared.getName((Model.shared.randomUsers?.results[indexPath.row])!), forValue: data!)
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!)
                    cell.textLabel?.text = Model.shared.getName(((Model.shared.randomUsers?.results[indexPath.row])!))
                    cell.setNeedsLayout()
                    print("success")
                }
                
            }
            cacheAndSetBlockOperation.addDependency(fetchImageOperation)
            imageFetchQueue.addOperations([fetchImageOperation, cacheAndSetBlockOperation], waitUntilFinished: false)
        }
    }
    //MARK: Propertires
    
    let randomUserController = RandomUserController()
    let cache = Cache<String, Data>()
    let imageFetchQueue = OperationQueue()
    let mainQ = DispatchQueue.self
}
