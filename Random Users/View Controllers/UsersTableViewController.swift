//
//  PersonsTableViewController.swift
//  Random Users
//
//  Created by Hector Steven on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		userController.fetchUsers { error in
			if let error = error {
				print("Error fetching usuer: \(error)")
			}
			DispatchQueue.main.async {
				print(self.userController.users.count)
				self.tableView.reloadData()
			}
		}
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userController.users.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
		guard let userCell = cell as? UserTableViewCell else { return  cell }
		
		
		let user = userController.users[indexPath.row]
		userCell.nameLabel?.text = user.name
		
		return  userCell
		
	}
	
	
	let userController = UserController()

}
