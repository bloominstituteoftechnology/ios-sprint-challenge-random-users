//
//  DetailViewController.swift
//  Random Users
//
//  Created by Dennis Rudolph on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var person: RandomPerson?
    var imageData: Data?

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailPhoneLabel: UILabel!
    @IBOutlet weak var detailEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let person = person, let imageData = imageData else { return }
        detailNameLabel.text = "\(person.name.title) \(person.name.first) \(person.name.last)"
        detailPhoneLabel.text = person.phone
        detailEmailLabel.text = person.email
        
        if isViewLoaded == true {
            detailImageView.image = UIImage(data: imageData)
        }
    }
}
