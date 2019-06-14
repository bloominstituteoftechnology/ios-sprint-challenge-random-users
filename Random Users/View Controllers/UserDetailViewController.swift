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
		setupViews()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func didMove(toParentViewController parent: UIViewController?) {
		
		if parent == nil {
			print("The back button was pressed")
			
		}
	}
	
	
	func setupViews() {
		guard let user = user else { return }
		
		nameLabel?.text = user.name
		emailLabel?.text = user.email
		
		
	}
	
	func fetchCurrentImage() {
		guard let user = user, let userIndex = userIndex else { return }
		
		if let imageData = userController?.largeImageCache.value(for: userIndex) {
			userImageView.image = UIImage(data: imageData)
		}
		
		let fetchPhotoOperation = FetchPhotoOperation(userImageUrl: user.picture[2])
		
		let storeToCache = BlockOperation {
			if let imageData = fetchPhotoOperation.imageData {
				self.userController?.largeImageCache.cache(value: imageData, for: userIndex)
			}
		}
		
		let setImageOp = BlockOperation {
			
		}
		
	}
	
	
	@IBOutlet var emailLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var userImageView: UIImageView!
	var user: User?
	var userIndex: Int?
	var userController: UserController?
}
