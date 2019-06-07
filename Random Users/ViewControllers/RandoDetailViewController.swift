//
//  RandoDetailViewController.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandoDetailViewController: UIViewController {

	@IBOutlet var userImageView: UIImageView!
	@IBOutlet var emailLabel: UILabel!
	@IBOutlet var phoneLabel: UILabel!
	@IBOutlet var cellLabel: UILabel!

	var user: RandomUser? {
		didSet {
			updateViews()
		}
	}

	private func updateViews() {
		guard let user = user, isViewLoaded else { return }
		navigationItem.title = user.fullNameWithTitle
		emailLabel.text = user.email
		phoneLabel.text = user.phone
		cellLabel.text = user.cell
	}

}
