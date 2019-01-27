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
        return Model.shared.randomUsersCount
    }
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
        if let data = cache.value(for: Model.shared.getName((Model.shared.randomUsers?.results[indexPath.row])!)) {
            cell.imageView?.image = UIImage(data: data)
            cell.textLabel?.text = Model.shared.getName((Model.shared.randomUsers?.results[indexPath.row])!)
        } else {
            let fetchImageOperation = FetchImageOperation()
            fetchImageOperation.indexPath = indexPath
            let cacheAndSetBlockOperation = BlockOperation {
                let data = fetchImageOperation.randomUserThumbnailData
                self.cache.cache(forKey: Model.shared.getName((Model.shared.randomUsers?.results[indexPath.row])!), forValue: data!)
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!)
                    cell.textLabel?.text = Model.shared.getName(((Model.shared.randomUsers?.results[indexPath.row])!))
                    cell.setNeedsLayout()
                }
                
            }
            cacheAndSetBlockOperation.addDependency(fetchImageOperation)
            dataQeue.sync {
            imageFetchQueue.addOperations([fetchImageOperation, cacheAndSetBlockOperation], waitUntilFinished: false)
            }
        }
    }
    
    
    //FIXME: Something in this code is causing a bug preventing me from selecting some cells after scrolling down rapidly and then scrolling back up a little bit. I'm not sure if `cell.prepareForReuse() is making any difference here
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !imageFetchQueue.operations.isEmpty {
            if imageFetchQueue.operations[0].isExecuting {
            imageFetchQueue.operations[0].cancel()
                cell.prepareForReuse()
            }
        }
    }
    //MARK: Propertires
    
    let dataQeue = DispatchQueue(label: "dataQueue")
    let randomUserController = RandomUserController()
    let cache = Cache<String, Data>()
    let imageFetchQueue = OperationQueue()
    let mainQ = DispatchQueue.self
}
