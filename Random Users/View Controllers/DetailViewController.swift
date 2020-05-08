//
//  DetailViewController.swift
//  Random Users
//
//  Created by Shawn James on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: Result?
    
    private func updateViews() {
        guard let user = user else { return }
        loadImage(user: user)
        nameLabel.text = "\(user.name.title.rawValue) \(user.name.first) \(user.name.last)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
    private func loadImage(user: Result) {
        guard let imageURL = URL(string: user.picture.large) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.largeImage.image = image
            }
        }
    }
    
}
