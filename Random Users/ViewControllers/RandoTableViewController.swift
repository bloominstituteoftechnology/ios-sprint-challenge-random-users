//
//  RandoTableViewController.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandoTableViewController: UITableViewController {
	let randomUserController = RandomUserController()

	override func viewDidLoad() {
		super.viewDidLoad()
		randomUserController.fetchUsers { [weak self] (result: Result<Data?, NetworkError>) in
			DispatchQueue.main.async {
				do {
					_ = try result.get()
				} catch {
					let alert = UIAlertController(error: error)
					self?.present(alert, animated: true)
				}
				self?.tableView.reloadData()
			}
		}
	}

}

// MARK: - TableView Stuff
extension RandoTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return randomUserController.users.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let user = randomUserController.users[indexPath.row]
		cell.textLabel?.text = user.fullName
		return cell
	}
}
