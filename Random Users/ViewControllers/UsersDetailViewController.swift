//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    var profileImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additielse onal setup after loading the view.
    }
    
    func updateViews() {
        guard let user = user else { return }
        userNameLabel.text = user.name.fullName
        phoneNumberLabel.text = user.phone
        emailAddressLabel.text = user.email
        userImage.image = profileImage
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
