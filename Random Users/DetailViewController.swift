//
//  DetailViewController.swift
//  Random Users
//
//  Created by Christy Hicks on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    // MARK:  Property
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
    // MARK: Views
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
