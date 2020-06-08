//
//  DetailViewController.swift
//  Random Users
//
//  Created by Dahna on 6/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        guard let user = user else { return }
        print("\(user.name.first)")
        
        let image = user.picture.large
        
        nameLabel.text = "Name: " + "\(user.name.first)" + " " + "\(user.name.last)"
        emailLabel.text = "Email: \(user.email)"
        phoneLabel.text = "Phone Number: \(user.phone)"
        
        URLSession.shared.dataTask(with: image) { data, _, error in
            
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(data: data)
            }
        }
        .resume()
    }
}
