//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by patelpra on 5/16/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    
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
