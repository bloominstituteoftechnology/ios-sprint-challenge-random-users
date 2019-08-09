//
//  DetailVC.swift
//  Random Users
//
//  Created by Seschwan on 8/2/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    var user: User? {
        didSet {
            self.updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = 8
        updateViews()
    }
    
    
    private func updateViews() {
        guard let user = self.user, isViewLoaded else { return }
        
        navigationItem.title = user.fullName
        self.nameLbl.text = "Name: \(user.fullName)"
        self.phoneLbl.text = "Phone #: \(user.phone)"
        self.emailLbl.text = "Email: \(user.email)"
        
        let url = user.large
        if let data = try? Data(contentsOf: url) {
            self.userImageView.image = UIImage(data: data)
        }
    }

}
