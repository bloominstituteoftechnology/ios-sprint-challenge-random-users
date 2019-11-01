//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by admin on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {

    @IBOutlet weak var usersImageView: UIImageView!
    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var usersPhoneNumberLabel: UILabel!
    @IBOutlet weak var usersEmailLabel: UILabel!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews() {
        guard let person = person else { return }
        
        usersNameLabel.text = "\(person.name.first) \(person.name.last)"
        usersPhoneNumberLabel.text = person.phone
        usersEmailLabel.text = person.email
        do {
            let data = try Data(contentsOf: person.picture.large)
            usersImageView.image = UIImage(data: data)
        } catch {
            NSLog("Error")
        }
    }

}
