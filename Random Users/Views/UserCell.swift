//
//  UserCell.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var nameLbl: UILabel!
	
	//MARK: - Properties
	
	var user: User? {
		didSet {
			configCell()
		}
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func configCell() {
		guard let user = user else { return }
		
		imgView.loadImage(from: user.picture.thumbnail)
		nameLbl.text = user.name
	}
}

