//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_259 on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {
    
    // MARK: - Properties
    var user: User?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else { return }
        loadImage()
        
        let name = user.name
        let title = name.title
        let first = name.first
        let last = name.last
        let fullName = "\(title.capitalized). \(first.capitalized) \(last.capitalized)"
        userNameLabel.text = fullName
        
        phoneNumberLabel.text = user.phone
        
        emailAddressLabel.text = user.email
    }
    
    func loadImage() {
        let url = URL(string: (user?.picture.large)!)!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching Large image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No valid Data from Large image fetch")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
    }

}
