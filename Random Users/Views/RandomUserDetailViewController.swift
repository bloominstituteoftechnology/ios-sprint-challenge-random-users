//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Joel Groomer on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    func updateViews() {
        guard let user = user else { return }
        if let data = try? Data(contentsOf: user.pictureLarge) {
            imgUser.image = UIImage(data: data)
        }
        lblName.text = "\(user.title) \(user.firstName) \(user.lastName)"
        lblPhone.text = user.phone
        lblEmail.text = user.email
    }

}
