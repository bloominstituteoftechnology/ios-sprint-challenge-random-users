//
//  Views.swift
//  Random Users
//
//  Created by William Bundy on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class PersonCell:UITableViewCell
{
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	var person:Person! {
		didSet {
			nameLabel.text = person.name
		}
	}

}

class PeopleListVC:UITableViewController
{
	var controller = PersonController.shared
	var fetches:[URL:FetchPhotoOperation] = [:]
	var queue = OperationQueue()

	override func viewDidLoad() {
		getNewPeople(self)
	}

	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}

	@IBAction func getNewPeople(_ sender: Any) {
		controller.load { error in
			if error != nil {
				return
			}

			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
		tableView.reloadData()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
		guard let cell = defaultCell as? PersonCell else { return defaultCell }
		cell.person = controller.people[indexPath.row]
		fetchPhoto(cell.person, cell, indexPath)
		return cell
	}

	func fetchPhoto(_ person:Person, _ cell:PersonCell, _ path:IndexPath)
	{
		if person.name == "Loading..." {
			cell.photoView.image = nil
			return
		}
		// no image to load? we're out of here
		guard let url = person.thumbImg else { return }

		// if it's in the cache? we're done
		if let thumb = controller.thumbs.retrieve(url) {
			cell.photoView.image = thumb
			return
		}

		// looks like we'll actually have to hit the network
		let fetch = FetchPhotoOperation(url)
		let complete = BlockOperation {
			DispatchQueue.main.async {
				if self.tableView.indexPath(for: cell) != path {
					return
				}
				cell.photoView.image = fetch.imageData
				self.fetches[url] = nil
			}
		}

		let cached = BlockOperation {

			if let img = fetch.imageData {
				self.controller.thumbs.store(url, img)
			} else {
				NSLog("Image data for \(url) was nil?")
			}
		}

		fetches[url] = fetch

		complete.addDependency(fetch)
		cached.addDependency(fetch)
		queue.addOperations([fetch, complete, cached], waitUntilFinished: false)
	}

	override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? PersonCell else { return }
		guard let url = cell.person.thumbImg else { return }
		if let fetch = fetches[url] {
			fetch.cancel()
			fetches[url] = nil
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return controller.people.count
	}

	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if let cell = sender as? PersonCell {
			if cell.person.name == "Loading..." {
				return false
			}
		}
		return true
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? PersonDetailVC {
			if let cell = sender as? PersonCell {
				dest.person = cell.person
			}
		}
	}
}

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
