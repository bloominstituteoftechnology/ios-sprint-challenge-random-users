//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Hector Steven on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		photoFetchQueue.name = "com.RandomeUsers.UserDetailViewController"
		setupViews()
		
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func didMove(toParentViewController parent: UIViewController?) {
		if parent == nil {
			fetchPhotoOperations?.cancel()
		}
	}
	
	
	func setupViews() {
		guard let user = user else { return }
		
		nameLabel?.text = user.name
		emailLabel?.text = user.email
		fetchCurrentImage(with: user.picture[2])
	}
	
	func fetchCurrentImage(with url: String) {
		guard let userIndex = userIndex else { return }
		
		if let imageData = userController?.largeImageCache.value(for: userIndex) {
			userImageView.image = UIImage(data: imageData)
		}
		
		let fetchPhotoOperation = FetchPhotoOperation(userImageUrl: url)
		
		let storeToCache = BlockOperation {
			if let imageData = fetchPhotoOperation.imageData {
				self.userController?.largeImageCache.cache(value: imageData, for: userIndex)
			}
		}
		
		let setImageOp = BlockOperation {
			guard let imageData = fetchPhotoOperation.imageData else { return }
			self.userImageView?.image = UIImage(data: imageData)
		}
		
		storeToCache.addDependency(fetchPhotoOperation)
		setImageOp.addDependency(fetchPhotoOperation)
		
		photoFetchQueue.addOperations([fetchPhotoOperation,storeToCache], waitUntilFinished: false)
		OperationQueue.main.addOperation(setImageOp)
		fetchPhotoOperations = fetchPhotoOperation
	}
	
	
	@IBOutlet var emailLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var userImageView: UIImageView!
	var user: User?
	var userIndex: Int?
	var userController: UserController?
	private let photoFetchQueue = OperationQueue()
	var fetchPhotoOperations: FetchPhotoOperation?
}
