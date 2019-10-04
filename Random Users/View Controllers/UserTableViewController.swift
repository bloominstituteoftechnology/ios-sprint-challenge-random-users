//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Jake Connerly on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        userController.fetchUsers { (users, error) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? CustomUserTableViewCell else { return UITableViewCell() }
        let user = userController.users[indexPath.row]
        let userName = "\(user.name.firstName) \(user.name.lastName)"
        cell.nameLabel.text = userName
        return cell
    }
    
    
}
