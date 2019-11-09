//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by John Kouris on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            if let person = person {
                
                nameLabel.text = person.name
                phoneNumberLabel.text = person.phone
                emailAddressLabel.text = person.email
                
                if let data = try? Data(contentsOf: person.picture) {
                    personImageView.image = UIImage(data: data)
                }
            }
        }
    }

}
