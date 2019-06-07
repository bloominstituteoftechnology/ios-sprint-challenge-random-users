//
//  PeopleTableViewCell.swift
//  Random Users
//
//  Created by Hector Steven on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

	func setupViews() {
		guard let person = person else { return }
		
		nameLabel.text = person.name
		
	}
	
	
	@IBOutlet var peopleImageView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	var person: Person?  {
		didSet { setupViews() }
		
	}
}
