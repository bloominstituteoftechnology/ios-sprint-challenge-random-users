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
	var imgData: Data? {
		didSet {
			loadImage()
		}
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func configCell() {
		guard let user = user else { return }
		nameLbl.text = user.name
	}
	
	private func loadImage() {
		guard let imgdata = imgData else { return }
		imgView.image = UIImage(data: imgdata)
	}
}

