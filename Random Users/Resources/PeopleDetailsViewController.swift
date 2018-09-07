//
//  PeopleDetailsViewController.swift
//  Random Users
//
//  Created by Vuk Radosavljevic on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleDetailsViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    
    // MARK: - Properties
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var person: Person?
    
    
    
    func updateViews() {
        guard let person = person else {return}
        nameLabel.text = person.name["title"]! + " " + person.name["first"]! + " " + person.name["last"]!
        emailLabel.text = person.email
        phoneNumberLabel.text = person.phone
        guard let imageLink = person.picture["large"] else {return}
        if let url = URL(string: imageLink) {
            do {
                let data = try Data(contentsOf: url)
                personImageView.image = UIImage(data: data)
            } catch let err {
                print("Error: \(err)")
            }
        }
    }
    
}
