//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var users: User? {
         didSet {
             updateViews()
         }
     }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        
    }

}
