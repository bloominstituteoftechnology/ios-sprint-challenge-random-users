//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if let user = user, isViewLoaded == true {
            nameLabel.text = ("\(user.name.first) \(user.name.last)")
            phoneNumberLabel.text = ("\(user.phone)")
            emailLabel.text = ("\(user.email)")
            
            let imageURL = user.picture.large
            
            URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                if let error = error {
                    print("Error Fetching Data: \(error)")
                    print("\(#file):L\(#line): Code failed inside \(#function)")
                }
                
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.largeImage.image = UIImage(data: data)
                }
            }.resume()
            
            
        }
    }
    
}
