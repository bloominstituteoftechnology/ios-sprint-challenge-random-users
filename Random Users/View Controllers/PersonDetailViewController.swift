//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by Marc Jacques on 5/17/20.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    var person: Person?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews() {
        guard let person = person,
        isViewLoaded == true else {return}


        nameLabel.text = person.name.first
        phoneLabel.text = person.phone
        emailLabel.text = person.email
        do {
        let data = try Data(contentsOf: person.picture.large)
            imageView.image = UIImage(data: data)
        } catch {
            NSLog("Error")
        }
    }
}


