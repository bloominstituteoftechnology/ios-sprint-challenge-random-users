//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Joe on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var personDelegate: Person?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func displayURLImage(url: String) -> UIImage {
        let imageURL = URL(string: url)!
        let data = try? Data(contentsOf: imageURL)
        let image = UIImage(data: data!)
        return image ?? UIImage(named: "notAvailable.jpg")!
    }
 
    func updateViews() {
        guard let user = personDelegate else { return }
        nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        image.image = displayURLImage(url: user.picture.medium)
        emailLabel.text = user.email
        phoneLabel.text = user.phone
    }
    


}
