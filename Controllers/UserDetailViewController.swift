//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Ian French on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit



class UserDetailViewController: UIViewController {

    var randomUser: UserResults?

    var randomUserController = RandomUsersController()

    private let cache = Cache<String, Data>()

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

        func updateViews() {
            guard let randomUser = randomUser else { return }

            userName.text = "\(randomUser.name.title) \(randomUser.name.first) \(randomUser.name.last)"
            userPhone.text = randomUser.phone
            userEmail.text = randomUser.email

            if let cacheData = cache.value(for: randomUser.email),
                let image = UIImage(data: cacheData) {
                userImage.image = image
                return
            }

            getImage(with: randomUser)


            switch randomUser.name.title {
            case "Miss", "Ms", "Mrs", "Madame":
                self.view.backgroundColor = UIColor.systemPink
            default:
                self.view.backgroundColor = UIColor.systemBlue
            }

        }

        func getImage(with user: UserResults) {
            let imagePath = user.picture.large
            randomUserController.getUserImage(path: imagePath) { (result) in

                guard let imageString = try? result.get() else { return }
                
                let image = UIImage(data: imageString)
                self.cache.cache(value: imageString, for: user.email)

                DispatchQueue.main.async {
                    self.userImage.image = image
                }
            }
        }
    }

