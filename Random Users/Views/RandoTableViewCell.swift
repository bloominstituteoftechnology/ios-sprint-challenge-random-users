//
//  RandoTableViewCell.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandoTableViewCell: UITableViewCell {

	var user: RandomUser? {
		didSet {
			updateViews()
		}
	}

	private func updateViews() {
		resetToPlaceholderImage()
		textLabel?.text = user?.fullName

		// trigger image load
	}

	override func prepareForReuse() {
		resetToPlaceholderImage()
	}

	private func resetToPlaceholderImage() {
		imageView?.image = #imageLiteral(resourceName: "skate")
	}
}
