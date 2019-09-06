//
//  UsersListVC.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersListVC: UITableViewController {

	//MARK: - IBOutlets
	
	
	//MARK: - Properties
	
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		#warning("Incomplete implementation, return the number of rows")
        return 0
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? UserCell else { return UITableViewCell() }

//		cell.user = 

        return cell
    }
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
			#error("Incomplete implementation, remove item from original list provided to tableView")
			tableView.deleteRows(at: [indexPath], with: .automatic)
			handler(true)
		}
		
		return UISwipeActionsConfiguration(actions: [delete])
	}
}
