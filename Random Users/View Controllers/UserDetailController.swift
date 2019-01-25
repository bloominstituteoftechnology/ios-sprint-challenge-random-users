//
//  UserDetailController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailController: UIViewController {
    
    override func viewDidLoad() {
        showUser()
    }
    
    //Outlets
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //Properties
    var currentUser: User?
    private var photoQueue = ConcurrentOperation()
    
    func showUser() {
        
        guard let photoURL = URL(string: (currentUser?.picture.large)!) else { return }
        guard let mainPhotoData = try? Data(contentsOf: photoURL) else { return }
        mainPhoto.image = UIImage(data: mainPhotoData)
        nameLabel.text = "\(currentUser?.name.first) \(currentUser?.name.last)"
        phoneLabel.text = "\(currentUser?.cell)"
        emailLabel.text = "\(currentUser?.email)"
    }
    
}
