//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by conner on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        username.text = user.name.displayName
        phone.text = user.phone
        email.text = user.email
        
        fetchImage()
    }
    
    private func fetchImage() {
        guard let user = user, let imageURL = URL(string: user.picture.large) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                NSLog("Failed to fetch image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Fetched image, no data")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image.image = image
            }
        }
        .resume()
    }
}
