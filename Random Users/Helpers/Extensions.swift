//
//  Extensions.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

extension UIImageView {
	func loadImage(from url: URL) {
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				print("Error fetching photo: \(error.localizedDescription)")
				return
			}
			
			guard let imgData = data else {
				print("No data found")
				return }
			
			DispatchQueue.main.async {
				self.image = UIImage(data: imgData)
			}
			}.resume()
	}
}
