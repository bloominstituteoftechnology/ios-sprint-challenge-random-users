
import Foundation
import UIKit
import CoreData

class PersonDetailVC:UIViewController
{
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!

	var person:Person!
	var controller:PersonController = PersonController()
	var queue = OperationQueue()

	override func viewWillAppear(_ animated: Bool) {
		guard let person = person else { return }
		nameLabel.text = person.name
		phoneLabel.text = "Phone: \(person.phone)"
		emailLabel.text = "Email: \(person.email)"
		loadPhoto(person)
	}

	func loadPhoto(_ person: Person)
	{
		// no image to load? we're out of here
		guard let url = person.largeImg else { return }

		// if it's in the cache? we're done
		if let img = controller.images.retrieve(url) {
			photoView.image = img
			return
		}

		// looks like we'll actually have to hit the network
		let fetch = FetchPhotoOperation(url)
		let complete = BlockOperation {
			DispatchQueue.main.async {
				self.photoView.image = fetch.imageData
			}
		}

		let cached = BlockOperation {
			if let img = fetch.imageData {
				self.controller.images.store(url, img)
			} else {
				NSLog("Image data for \(url) was nil?")
			}
		}
		complete.addDependency(fetch)
		cached.addDependency(fetch)
		queue.addOperations([fetch, complete, cached], waitUntilFinished: false)
	}
}
