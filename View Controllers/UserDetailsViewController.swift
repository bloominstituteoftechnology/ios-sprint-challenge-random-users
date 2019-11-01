//
//  UserDetailsViewController.swift
//  Random Users
//
//  Created by macbook on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    //Properties
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    // VIewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //Update
    func updateViews() {
        guard let user = user,
            isViewLoaded else { return }
        
        self.nameLabel.text = "\(user.name.first) \(user.name.last)"
        self.emailLabel.text = user.email
        self.phoneNumLabel.text = user.phone
        //.userImage.image = user.picture.large
        
        
        let imageURL = user.picture.large
        if let imageData = try? Data(contentsOf: imageURL),
            let largePicture = UIImage(data: imageData) {
            userImage.image = largePicture
        }
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
