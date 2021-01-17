//
//  DetailViewController.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    let cache = Cache<String, Data>()
    var userController: UserController?
    var userResults: UsersResults?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
        
        updateViews()
    }


    func updateViews() {

        guard let user = userResults else { return }

        nameLabel.text = "Name: \(user.name.title) \(user.name.first) \(user.name.first)"
        print("User label prints")
        phoneNumberLabel.text = "Phone Number: \(user.phone)"
        emailLabel.text = "Email: \(user.email)"

//        if let imageCashe = cache.getValue(for: user.email),
//            let image = UIImage(data: imageCashe) {
//            userImageView.image = image
//            print("image prints")
//        }
    }
    
    func fetchImage() {
        guard let user = userResults else { return }
        userController?.fetchUserImage(at: user.picture.large, completion: { (result) in
            
            do {
                let imageString = try result.get()
                let image = UIImage(data: imageString)
                self.cache.cache(value: imageString, for: user.email)
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            } catch {
                print("Failed to get images")
            }
        })
    }
}
