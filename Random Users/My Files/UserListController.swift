//
//  UserListController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserListController: UITableViewController {
    
    let managerRef = UserManager()
    
    //Set up rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return managerRef.addressbook.count
    }
    
    //Set up cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let basicCell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        //Use my custom cell or the regular cell if impossible
        guard let cell = basicCell as? UserCellController else { return basicCell }
        
        return cell
    }
    
    //Pass selected cell information via segue to detail view as index path
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" { let detailVC = segue.destination as! UserDetailController }
        
    }
}
