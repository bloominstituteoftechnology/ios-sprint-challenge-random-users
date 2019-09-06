//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Marlon Raskin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

	let userClient = UserClient()
	let cache = Cache<URL, Data>()
	var storedFetchOperations: [URL: FetchPhotoOperation] = [:]
	private let photoFetchQueue = OperationQueue()
	let queue = DispatchQueue(label: "CancelOperationQueue")

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		userClient.fetchUsers { (error) in
			if let error = error {
				NSLog("Error fetching users: \(error)")
				return
			}

			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
    }

//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//		tableView.reloadData()
//	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userClient.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
		let user = userClient.users[indexPath.row]
		cell.nameLabel.text = "\(user.name.title.capitalized) \(user.name.first.capitalized) \(user.name.last.capitalized)"
		loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }

	override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let user = userClient.users[indexPath.row]
		let operation = storedFetchOperations[user.picture.large]
		queue.sync {
			operation?.cancel()
		}
	}


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetailSegue" {
			guard let detailVC = segue.destination as? DetailViewController,
				let indexPath = tableView.indexPathForSelectedRow else { return }
			let user = userClient.users[indexPath.row]
			detailVC.user = user
			detailVC.userClient = userClient
		}
    }

	private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
		let user = userClient.users[indexPath.row]
		let photoURL = user.picture.large

		if let imageData = cache.value(for: photoURL) {
			let image = UIImage(data: imageData)
			cell.userImageView.image = image
			return
		}

		let fetchPhotoOperation = FetchPhotoOperation(user: user)

		let storeDataInCache = BlockOperation {
			guard let imageData = fetchPhotoOperation.imageData else { return }
			self.cache.cache(value: imageData, for: photoURL)
		}

		let setImageAndName = BlockOperation {
			defer {
				self.storedFetchOperations.removeValue(forKey: user.picture.large)
			}

			if let currentIndexPath = self.tableView.indexPath(for: cell),
				currentIndexPath != indexPath {
				return
			}

			guard let imageData = fetchPhotoOperation.imageData else { return }
			cell.userImageView.image = UIImage(data: imageData)
		}

		storeDataInCache.addDependency(fetchPhotoOperation)
		setImageAndName.addDependency(fetchPhotoOperation)

		photoFetchQueue.addOperation(fetchPhotoOperation)
		photoFetchQueue.addOperation(storeDataInCache)
		OperationQueue.main.addOperation(setImageAndName)

		storedFetchOperations[user.picture.large] = fetchPhotoOperation
	}
}
