//
//  DetailViewController.swift
//  Random Users
//
//  Created by Thomas Cacciatore on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    
    }
    
    private func updateViews() {
        if let user = user {
            print(user)
            nameLabel?.text = user.name
            phoneLabel?.text = user.phone
            emailLabel?.text = user.email
            let url = user.largeImageURL
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                detailImageView?.image = image
            }
        }
    }
    

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
}
