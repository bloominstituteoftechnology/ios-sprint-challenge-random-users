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
    
    var person: Person?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews() {
        guard let person = person else {return}


        nameLabel.text = person.name.first
        do {
        let data = try Data(contentsOf: person.picture.large)
            imageView.image = UIImage(data: data)
        } catch {
            NSLog("Error")
        }
    }
}


