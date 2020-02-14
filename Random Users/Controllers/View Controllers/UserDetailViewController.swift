//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Aaron Cleveland on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    private func updateViews() {
        guard let user = self.user,
            isViewLoaded else { return }
        
        self.userName.text = user.name
        self.userEmail.text = user.email
        self.userPhoneNumber.text = user.phone
        
        let url = user.largeImage
        if let data = try? Data(contentsOf: url) {
            self.userImageView.image = UIImage(data: data)
        }
    }
}
