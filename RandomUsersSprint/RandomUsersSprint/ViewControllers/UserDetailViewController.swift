//
//  UserDetailViewController.swift
//  RandomUsersSprint
//
//  Created by Luqmaan Khan on 9/6/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userNumber: UILabel!
    @IBOutlet var userEmailAddress: UILabel!
   
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else {return}
        userName.text = "\(user.title).\(user.first) \(user.last)"
        userNumber.text = user.phone
        userEmailAddress.text = user.email
        
    URLSession.shared.dataTask(with: user.large ) { (data, _, error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            guard let data = data else {return}
        DispatchQueue.main.async {
            self.userImage.image = UIImage(data: data)
        }
        }.resume()
    }
    }

