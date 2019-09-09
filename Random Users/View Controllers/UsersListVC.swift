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
	
	private let usersController = UsersController()
	private var thumbCache = Cache<String, Data>()
	private let photofetchQueue = OperationQueue()
	private var storedFetchOps = [String:FetchPhotoOperation]()
	private let cancelQueue = DispatchQueue(label: "MyCancelationOps")
	
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

		let user = usersController.users[indexPath.row]
		var userImgData: Data?
		let cacheKey = user.picture.thumbnail.absoluteString
		
		if let imgData = thumbCache.value(for: cacheKey) {
			userImgData = imgData
			cell.configCell(with: user, and: userImgData)
		} else {
			let fetchPhotoOp = FetchPhotoOperation(user: user)
			let cacheOp = BlockOperation {
				if let photoData = fetchPhotoOp.imageData {
					self.thumbCache.cache(value: photoData, for: cacheKey)
				}
			}
			
			let cellCheckOp = BlockOperation {
				if let cellPath = tableView.indexPath(for: cell), cellPath != indexPath {
					return
				}
				if let imgData = fetchPhotoOp.imageData {
					userImgData = imgData
					cell.configCell(with: user, and: userImgData)
				}
			}
			
			cacheOp.addDependency(fetchPhotoOp)
			cellCheckOp.addDependency(fetchPhotoOp)
			
			photofetchQueue.addOperations([fetchPhotoOp, cacheOp], waitUntilFinished: false)
			OperationQueue.main.addOperation(cellCheckOp)
			
			storedFetchOps.updateValue(fetchPhotoOp, forKey: user.login.uuid)
		}
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let userId = usersController.users[indexPath.item].login.uuid		
		guard let fetchOp = storedFetchOps[userId] else { return }
		
		cancelQueue.sync {
			fetchOp.cancel()
		}
	}
}
