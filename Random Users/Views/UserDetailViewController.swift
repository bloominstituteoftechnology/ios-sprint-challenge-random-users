//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Outlets
    @IBOutlet var largeImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    // MARK: - Methods
    func updateViews() {
        guard isViewLoaded else { return }
        guard let user = user else { return }
        print(user)
        nameLabel.text = user.name.fullName
        phoneNumberLabel.text = user.phone
        emailLabel.text = user.email
        
         let largePicture = user.picture.large
                let request = URLRequest(url: largePicture)

                URLSession.shared.dataTask(with: request) {data, _, error in
                    guard let data = data else {
                        NSLog("Did not find large picture from data")
                        return
                    }
                    if let error = error {
                        NSLog("Error fetching large picture: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.largeImageView.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
