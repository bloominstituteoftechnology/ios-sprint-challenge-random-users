//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userPhoneLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    private func updateView() {
        guard let user = user else {
            NSLog("User is null")
            return
        }
        userNameLabel.text = user.getName()
        userPhoneLabel.text = user.phone
        userEmailLabel.text = user.email
        
        getImageAsync()
    }
    
    private func getImageAsync() {
        if let user = user {
            DispatchQueue.main.async {
                let imageURL = URL(string: user.picture.large)!
                do {
                    let image = try Data(contentsOf: imageURL)
                    self.userImageView.image = UIImage(data: image)
                } catch {
                    NSLog("Error retrieving full sized image from server")
                }
            }
        }
    }

}
