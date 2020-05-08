//
//  DetailViewController.swift
//  Random Users
//
//  Created by Chris Dobek on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    // MARK: - Properties
    var user: User?
    
    // MARK: - Methods
    func updateViews(){
        guard let user = user else { return }
        loadImage(user: user)
        userName.text = user.name
        userEmail.text = user.email
        userPhone.text = user.phone
    }
    
    private func loadImage(user: User) {
        guard let imageURL = URL(string: user.picture.large) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.largeImage.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
}
