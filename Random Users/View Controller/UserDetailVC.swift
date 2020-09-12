//
//  UserDetailVC.swift
//  Random Users
//
//  Created by Norlan Tibanear on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user: UserResults?
    var userController: UserController?
    let cache = Cache<String, Data>()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }
    
    func updateView() {
        guard let user = user else { return }
        
        nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        if let cacheImage = cache.value(for: user.email),
            let image = UIImage(data: cacheImage){
            userImageView.image = image
        }
        getImage()
    }
    
    private func getImage() {
        guard let user = user else { return }
        userController?.getUserImage(path: user.picture.large, completion: { (result) in
            
            do {
                let imageString = try result.get()
                let image = UIImage(data: imageString)
                self.cache.cache(value: imageString, for: user.email)
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            } catch {
                print("Error getting user image")
            }
        })
    }

}//
