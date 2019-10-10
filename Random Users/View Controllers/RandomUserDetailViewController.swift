//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {
    
    var userController: UserController?
    var user: User?
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let user = user else { return }
        if let url = URL(string: user.picture.large) {
            if let data = try? Data(contentsOf: url) {
               largeImage.image = UIImage(data: data)
            }
        }
        name.text = user.name.first + " " + user.name.last
        email.text = user.email
        phone.text = user.phone
    }
}
