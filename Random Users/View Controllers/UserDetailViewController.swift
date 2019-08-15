//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Stephanie Bowles on 8/15/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var largeImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        guard let user = self.user,
        let name = nameLabel,
        let email = emailLabel,
        let phone = phoneLabel,
        let image = largeImageView else {return}
        
        name.text = user.name
        phone.text = user.phone
        email.text  = user.email
        
        let url = user.largePic
        if let data = try? Data(contentsOf: url) {
           image.image = UIImage(data: data)
        }
        
    }
  
    

}
