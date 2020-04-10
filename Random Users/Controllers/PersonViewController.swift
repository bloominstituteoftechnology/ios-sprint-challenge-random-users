//
//  PersonViewController.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    // MARK: - Properties
    var person: User? {
        didSet {
            updateViews()
        }
    }
    
    var largeImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Actions

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Private
    private func updateViews() {
        if let person = person {
            nameLabel?.text = person.name.fullName
            phoneLabel?.text = person.phone
            emailLabel?.text = person.email

            portraitImageView?.image = largeImage
        }
    }
}
