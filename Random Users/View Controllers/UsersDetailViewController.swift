//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {

    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!

    // MARK: - Properties
    
    var user: User? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // Update view with current user info
    private func updateViews() {
        guard isViewLoaded, let user = user else { return }
        
        title = user.name
        
        userNameLabel.text = user.name
        userPhoneLabel.text = user.phone
        userEmailLabel.text = user.email
        
        let imageURL = user.largeImage
        loadImage(from: imageURL)
    }
    
    // Load large image from api
    private func loadImage(from imageURL: URL) {
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error receiving data.")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.userImageview.image = image
            }
        }.resume()
    }
}
