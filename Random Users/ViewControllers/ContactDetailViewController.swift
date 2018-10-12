//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    var user: Users.User?

    @IBOutlet weak var largeImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.updateViews()
        }
        // Do any additional setup after loading the view.
    }
    
    func updateViews(){
        
        guard let user = user else {return}
        
        nameLabel.text = user.name
        
    }
    

}
