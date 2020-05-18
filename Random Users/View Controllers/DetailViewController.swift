//
//  DetailViewController.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var userDetail: User?
    
    @IBOutlet weak var userDetailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        nameLabel.text = "\(userDetail!.name.title) \(userDetail!.name.first) \(userDetail!.name.last)"
        emailLabel.text = userDetail?.email
        phoneLabel.text = userDetail?.phone
        getUserImage()
    }

    func getUserImage() {
        guard let image = userDetail?.picture.large else { return }
        if let url = URL(string: image) {
            do {
                let data = try Data(contentsOf: url)
                self.userDetailImage.image = UIImage(data: data)
            } catch {
                NSLog("Error getting user Thumbnail image")
            }
        }
    }
    
}
