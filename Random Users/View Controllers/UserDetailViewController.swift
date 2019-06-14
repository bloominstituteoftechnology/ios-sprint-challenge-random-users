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
	
	@IBOutlet var emailLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var userImageView: UIStackView!
	
}
