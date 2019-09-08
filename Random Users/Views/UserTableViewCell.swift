//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Marlon Raskin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

	let selectedView = UIView()

	var user: User? {
		didSet {
			updateViews()
		}
	}

	override func prepareForReuse() {
		userImageView.image = nil
		nameLabel.text = nil
		super.prepareForReuse()
	}

	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
		userImageView.layer.cornerRadius = userImageView.frame.height / 2
//		let selectedView = UIView()
//		selectedView.clipsToBounds = true
//		self.selectedBackgroundView = selectedView
		addSubview(selectedView)
		selectedView.translatesAutoresizingMaskIntoConstraints = false
		selectedView.frame = CGRect(x: 0, y: 0, width: 3.0, height: self.frame.height)
		selectedView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
		selectedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 3).isActive = true
		selectedView.widthAnchor.constraint(equalToConstant: 8).isActive = true
		selectedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    }

	func updateViews() {
		guard let user = user else { return }
		nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
	}

	private func showSelectionView(show: Bool, animated: Bool) {
		selectedView.backgroundColor = UIColor(red: 0.90, green: 0.38, blue: 0.35, alpha: 1.00)

		if animated {
			UIView.animate(withDuration: 0.7) {
				self.selectedView.alpha = show ? 1 : 0
			}
		} else {
			selectedView.alpha = show ? 1 : 0
		}
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		showSelectionView(show: selected, animated: animated)
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		showSelectionView(show: highlighted, animated: animated)
	}
}
