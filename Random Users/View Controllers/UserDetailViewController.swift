//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Hunter Oppel on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Properties
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    private func update() {
        guard let user = user else { return }
        userLabel.text = user.name.fullName
        phonenumberLabel.text = user.phone
        emailLabel.text = user.email
        loadImage()
    }
    
    private func loadImage() {
        
        guard let user = user,
            let imageURL = URL(string: user.picture.large) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                NSLog("Failed to fetch with error: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Fetch returned with no data")
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.largeImageView.image = image
            }
        }
        .resume()
    }
}
