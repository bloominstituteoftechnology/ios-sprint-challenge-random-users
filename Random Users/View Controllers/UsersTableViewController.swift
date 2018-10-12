//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var userController = UserController()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        
        return cell
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    
    @IBAction func addUsersButton(_ sender: Any) {
    }
    
}
