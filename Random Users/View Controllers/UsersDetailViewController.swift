//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Juan M Mariscal on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        if let user = user {
            let title = user.name.title
            let firstName = user.name.first
            let lastName = user.name.last
            let image = user.picture.large
            
            userImageView.image = UIImage(named: image)
            userNameLabel.text = "\(title) \(firstName) \(lastName)"
            userPhoneNumber.text = user.phone
            userEmailLabel.text = user.email
        }
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
