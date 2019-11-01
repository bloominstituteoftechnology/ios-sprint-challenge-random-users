//
//  DetailViewController.swift
//  Random Users
//
//  Created by Gi Pyo Kim on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var personImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var imageData: Data?
    var name: Name?
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
        guard let person = person, let imageData = imageData, let name = name, isViewLoaded else { return }
        
        if let image = UIImage(data: imageData) {
            personImageVIew.image = image
        }
        
        nameLabel.text = "\(name.title) \(name.first) \(name.last)"
        phoneNumLabel.text = person.phone
        emailLabel.text = person.email
        
    }
}
