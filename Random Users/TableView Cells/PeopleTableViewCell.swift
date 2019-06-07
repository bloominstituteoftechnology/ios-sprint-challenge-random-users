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
		
		fetchSetImage(with: person)
//		if let row = row {
//			print(row)
//			if let imageData = peopleController?.thumbnailImageCache.value(for: row) {
//				let img = UIImage(data: imageData)
//				self.peopleImageView.image = img
//			} else {
//				fetchSetImage(with: person)
//			}
//		}
		//nameLabel.text = person.name
		
//		if let imageData = peopleController?.thumbnailImageCache.value(for: row) {
//			let img = UIImage(data: imageData)
//			self.peopleImageView.image = img
//		} else {
			//fetchSetImage(with: person)
//		}
	}
	
	func fetchSetImage(with person: Person) {
		guard let url = URL(string: person.picture[0]) else {return}
		
		let shared = URLSession.shared
		shared.dataTask(with: url) { data, response, error in
			if let response = response as? HTTPURLResponse {
				NSLog("Response Code: \(response.statusCode)")
			}
			
			if let error = error {
				NSLog("Error fetching data \(error)")
				
				return
			}
			
			guard let data = data else { return }
			print(data)
			
			let img = UIImage(data: data)
			
			DispatchQueue.main.async {
//				self.peopleController?.thumbnailImageCache.cache(value:)
				self.peopleImageView.image = img
			}
			}.resume()
	}
	
	@IBOutlet var peopleImageView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	var peopleController: PeopleController?
	var person: Person?  { didSet { setupViews() } }
	var row: Int?
}
