//
//  ContactManagerTableViewController.swift
//  Random Users
//
//  Created by Clayton Watkins on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactManagerTableViewController: UITableViewController {

    // MARK: - Properties
    var apiController = APIController()
    var contacts: [Contact] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private let cache = Cache<String, Data>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        updateCell(forCell: cell, forItemAt: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Private Functions
    private func updateCell(forCell cell: ContactTableViewCell, forItemAt indexpath: IndexPath){
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

}
