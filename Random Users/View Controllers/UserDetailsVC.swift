//
//  UserDetailsVC.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailsVC: UIViewController {

	//MARK: - IBOutlets
	
	@IBOutlet weak var imgview: UIImageView!
	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var phoneLbl: UILabel!
	@IBOutlet weak var emailLbl: UILabel!
	
	//MARK: - Properties
	
	var user: User?
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateViews()
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func updateViews() {
		guard let user = user else { return }
		
		imgview.loadImage(from: user.picture.large)
		nameLbl.text = user.name
		phoneLbl.text = user.phone
		emailLbl.text = user.email
	}
}
