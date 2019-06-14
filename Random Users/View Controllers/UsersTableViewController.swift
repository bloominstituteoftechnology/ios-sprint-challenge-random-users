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
		
		photoFetchQueue.name = "com.RandomeUsers.PhotFectchQueue"
		
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
		
		loadImage(forCell: userCell, forItemAt: indexPath)
		
		return  userCell
	}
	
	private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
		
		if let imageData = thumbnailCache.value(for: indexPath.row) {
			cell.userImageView?.image = UIImage(data: imageData)
		}
		
		let user = userController.users[indexPath.row]
		let fetchPhotoOperation = FetchPhotoOperation(userImageUrl: user.picture[0])
		
		let storeToCache = BlockOperation {
			if let imageData = fetchPhotoOperation.imageData {
				self.thumbnailCache.cache(value: imageData, for: indexPath.row)
			}
		}
		
		let cellReusedCheck = BlockOperation {
			if self.tableView.indexPath(for: cell) == indexPath {
				guard let imageData = fetchPhotoOperation.imageData else { return }
				cell.userImageView.image = UIImage(data: imageData)
			}
		}
		
		storeToCache.addDependency(fetchPhotoOperation)
		cellReusedCheck.addDependency(fetchPhotoOperation)
		
		photoFetchQueue.addOperations([fetchPhotoOperation, storeToCache], waitUntilFinished: false)
		OperationQueue.main.addOperation(cellReusedCheck)
		fetchPhotoOperations[indexPath.row] = fetchPhotoOperation
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
	}

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowUserSegue" {
			guard let vc = segue.destination as? UserDetailViewController,
				let indexpath = tableView.indexPathForSelectedRow	else { return }
			
			let user = userController.users[indexpath.row]
			vc.user = user
		}
	}
	
	
	let userController = UserController()
	var fetchPhotoOperations: [Int: FetchPhotoOperation] = [:]
	private let photoFetchQueue = OperationQueue()
	var thumbnailCache = Cache<Int, Data>()
}
