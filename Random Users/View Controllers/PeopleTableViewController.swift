//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Hector Steven on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		peopleController.fetch { _ in
			print("Done Getting data")
			DispatchQueue.main.async {
				
				self.tableView.reloadData()
			}
		}

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return peopleController.poeple.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
		guard let peopleCell = cell as? PeopleTableViewCell else { return cell }
		
		let person =  peopleController.poeple[indexPath.row]
		peopleCell.person = person
		
		return peopleCell
	}
	
	
	let peopleController = PeopleController()
}
