//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by Alex Rhodes on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews() {
        guard let person = person else {return}
        nameLabel.text = person.name[0]
    }
}
