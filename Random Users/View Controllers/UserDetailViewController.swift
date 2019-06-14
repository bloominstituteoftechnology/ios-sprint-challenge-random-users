//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Hector Steven on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
		//cache and fetch
	}
	
	
	@IBOutlet var emailLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var userImageView: UIStackView!
	var user: User? { didSet { setupViews() } }
}
