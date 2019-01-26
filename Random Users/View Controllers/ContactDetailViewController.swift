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
        self.title = "\(user.name.title) \(user.name.last)"
        contactNameLabel.text = fullName
        contactEmailLabel.text = user.email
        contactPhoneNumberLabel.text = user.phone
        let urlString = user.picture.large
        guard let url = URL(string: urlString) else { return }
        
        do {
            let imageData = try Data(contentsOf: url)
            DispatchQueue.main.async {
                self.contactImageView.image = UIImage(data: imageData)
            }
            
        } catch {
            print("Something went wrong loading the image")
        }
        
    }
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!

    var user: RandomUser?
}
