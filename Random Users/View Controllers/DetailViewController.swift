//
//  DetailViewController.swift
//  Random Users
//
//  Created by Hector Steven on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

	}
	
	func setupView() {
		guard let person = person else { return }
		print(person)
		
		//picture = [thumbnail, large]
		guard let url = URL(string: person.picture[1]) else {return}
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
				self.personImageView.image = img
				self.nameLabel.text = person.name
				self.phoneNumberLabel.text = person.phone
				self.emailLabel.text = person.email
			}
		}.resume()
	}

	@IBOutlet var personImageView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var phoneNumberLabel: UILabel!
	@IBOutlet var emailLabel: UILabel!
	
	var person: Person? { didSet{ setupView() } }
}
