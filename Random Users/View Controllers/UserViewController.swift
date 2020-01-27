//
//  UserViewController.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    // MARK: - Properties
    var userController: UserController?
    var friend: Friend? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var userLargeImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let friend = friend,
        let userController = userController else { return }
        userNameLabel.text = "\(friend.title) \(friend.first) \(friend.last)"
        userPhoneLabel.text = friend.phone
        userEmailLabel.text = friend.email
        
        userController.fetchImage(at: friend.large, completion: { (image, error) in
            if let image = image {
                DispatchQueue.main.async {
                    self.userLargeImageView.image = image
                }
            }
        })
    }

}
