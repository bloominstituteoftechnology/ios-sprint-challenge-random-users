//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let user = user else {fatalError("no user passed")}
        let fullName = "\(user.name.title) \(user.name.first) \(user.name.last)"
        contactNameLabel.text = fullName
        contactEmailLabel.text = user.email
        contactPhoneNumberLabel.text = user.phone

    }
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!

    var user: RandomUser?
}
