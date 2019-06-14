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

	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
		guard let userCell = cell as? UserTableViewCell else { return  cell }
		
		userCell.nameLabel?.text = "\(indexPath.row)"
		
		return  userCell
		
	}
	
	
	let userController = UserController()

}
