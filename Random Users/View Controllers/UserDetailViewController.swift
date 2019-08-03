//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Michael Stoffer on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var email: UILabel!
    
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    // MARK: - Methods
    private func updateViews() {
        guard let user = self.user, isViewLoaded else { return }
        
        self.name.text = user.name
        self.phone.text = user.phone
        self.email.text = user.email
        
        let url = user.largeImage
        if let data = try? Data(contentsOf: url) {
            self.userImage.image = UIImage(data: data)
        }
    }
}
