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
	
	let usersController = UsersController()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadUsers()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let detailsVC = segue.destination as? UserDetailsVC, let indexPath = tableView.indexPathForSelectedRow {
			detailsVC.user = usersController.users[indexPath.row]
		}
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func loadUsers() {
		usersController.getUsers { (result) in
			switch result {
			case .success(_):
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			case .failure(let error):
				print("Error loading users: \(error)")
			}
		}
	}
	
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usersController.users.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else { return UITableViewCell() }

		cell.user = usersController.users[indexPath.row]

        return cell
    }
	
//	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
//			#error("Incomplete implementation, remove item from original list provided to tableView")
//			tableView.deleteRows(at: [indexPath], with: .automatic)
//			handler(true)
//		}
//
//		return UISwipeActionsConfiguration(actions: [delete])
//	}
}
