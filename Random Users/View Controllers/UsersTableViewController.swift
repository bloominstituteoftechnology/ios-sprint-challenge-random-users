//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    //MARK: - Properties -
    let segueID = "UserDetailSegue"
    var fetchedUsers: [User] = []
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
    // MARK: - Table View Datasource -
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? UserTableViewCell else { return UserTableViewCell() }
        
        cell.user = fetchedUsers[indexPath.row]
        cell.userNameLabel.text = cell.user?.name
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == segueID {
            guard let detailVC = segue.destination as? UserDetailViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            detailVC.user = fetchedUsers[index.row]
        }
    }
    
    
    //MARK: - Methods -
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
    }
    

}
