//
//  DetailViewController.swift
//  Random Users
//
//  Created by Joseph Rogers on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    private func updateViews() {
        guard let user = self.user,
            isViewLoaded else { return }
        
        self.userName.text = user.name
        self.userEmail.text = user.email
        self.userPhone.text = user.phone
        
        let url = user.largeImage
        if let data = try? Data(contentsOf: url) {
            self.userImage.image = UIImage(data: data)
        }
    }
}
