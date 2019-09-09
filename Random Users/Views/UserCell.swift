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
	
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	func configCell(with user: User, and imgData: Data?) {
		nameLbl.text = user.name
		if let imgData = imgData {
			imgView.image = UIImage(data: imgData)
		}
	}
}

