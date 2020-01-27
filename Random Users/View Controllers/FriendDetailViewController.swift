//
//  FriendDetailViewController.swift
//  Random Users
//
//  Created by Craig Swanson on 1/27/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class FriendDetailViewController: UIViewController {
    
    var userController: UserController?
    var friend: Friend?
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendPhoneLabel: UILabel!
    @IBOutlet weak var friendEmailLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let friend = friend else { return }
        friendNameLabel.text = "\(friend.title) \(friend.first) \(friend.last)"
        friendPhoneLabel.text = friend.phone
        friendEmailLabel.text = friend.email
        
        userController?.fetchImage(at: friend.large, completion: { (result) in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.friendImageView.image = image
                }
            }
        })
    }
}
