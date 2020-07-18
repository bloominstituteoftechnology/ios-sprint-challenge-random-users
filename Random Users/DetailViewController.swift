//
//  DetailViewController.swift
//  Random Users
//
//  Created by Bohdan Tkachenko on 7/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let user = user else { return }
        
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        let url = user.image
        if let data = try? Data(contentsOf: url) {
            userImageView.image = UIImage(data: data)
        }
    }
    
}
