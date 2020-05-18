//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: - Properties and IBOutlets -
    
    var userController = UserController()

    //MARK: - Methods and IBActions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        userController.getUser(completion: { _ in } )

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
    }
    

} //End of class
