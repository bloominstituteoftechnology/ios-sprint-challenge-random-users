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
//        randomUserController.fetchRandomUsers { (error) -> (Void) in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(Model.shared.randomUsers?.results.count)
        return Model.shared.randomUsersCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        loadRandomUser(forCell: cell, forItemAt: indexPath)
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RandomUserDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destination.randomUser = Model.shared.randomUsers?.results[indexPath.row]
    }
    private func loadRandomUser(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let randomUser = cache.getValueWithIndex(index: indexPath.row) else {
            if let randomUser = randomUserController.fetchSingleRandomUser(completionHandler: {_ in }) {
            cache.cache(forKey: (randomUser.email), forValue: randomUser)
            cell.textLabel?.text = Model.shared.getName(randomUser)
            cell.imageView?.image = Model.shared.getImage((randomUser.picture.thumbnail))
            }
            return
        }
        cell.textLabel?.text = Model.shared.getName(randomUser)
        cell.imageView?.image = Model.shared.getImage(randomUser.picture.thumbnail)
        cache.cache(forKey: randomUser.email, forValue: randomUser)
    }
    //MARK: Propertires
    
    let randomUserController = RandomUserController()
    let cache = Cache<String, RandomUser>()

}
