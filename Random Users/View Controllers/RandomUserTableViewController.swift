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
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RandomUserDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destination.randomUser = Model.shared.randomUsers?.results[indexPath.row]
    }
    private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        guard let randomUserThumbnail = Model.shared.randomUsers?.results[indexPath.row].picture.thumbnail else {return}
        if let data = cache.value(for: (randomUserThumbnail)) {
            cell.imageView?.image = UIImage(data: data)
            cell.textLabel?.text = Model.shared.getName((Model.shared.randomUsers?.results[indexPath.row])!)
        } else {
            do {
                let data = try Data(contentsOf: URL(string: randomUserThumbnail)!)
                cell.imageView?.image = UIImage(data: data)
                cell.textLabel?.text = Model.shared.getName((Model.shared.randomUsers?.results[indexPath.row])!)
                cache.cache(forKey: randomUserThumbnail, forValue: data)
            } catch {
                fatalError("Could not turn thumbnail url into data.")
            }
            //TODO: must cancel no-longer-needed fetches as rows scroll off screen
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.prepareForReuse()
    }
    //MARK: Propertires
    
    let randomUserController = RandomUserController()
    let cache = Cache<String, Data>()

}
