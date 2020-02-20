//
//  DetailViewController.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        print("updateViews() called")
        guard isViewLoaded else {return}
        
        guard let user = user else {return}
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        guard let imageData = try? Data(contentsOf: user.largeUrl) else {return}
        imageView.image = UIImage(data: imageData)
    }    
}
