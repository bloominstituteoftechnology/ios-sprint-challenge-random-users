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
			
		}
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func configCell() {
		guard let user = user else { return }
		
		DispatchQueue.global().async {
			if let data = try? Data(contentsOf: user.picture.thumbnail), let image = UIImage(data: data) {
				DispatchQueue.main.async {
					self.imgView.image = image
				}
			}
		}
		nameLbl.text = user.name
	}
}

