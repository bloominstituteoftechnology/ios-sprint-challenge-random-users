//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Juan M Mariscal on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    private let cache = Cache<Int, UIImage>()
    let userController = UserController()
    var user: User?
    //var userPhoto: User.Picture
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? UsersTableViewCell else {
            fatalError("Can't dequeue cell of type 'UsersCell'")
        }
        // Configure the cell...
        let user = userController.userList[indexPath.row]
        
        cell.userNameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        cell.userImageView.image = UIImage(named: user.picture.thumbnail)

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
