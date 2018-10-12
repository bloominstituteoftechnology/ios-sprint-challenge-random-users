//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Daniela Parra on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded,
            let user = user else { return }
        
        title = user.name
        
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        let imageURL = user.fullSizeURL
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned.")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.photoImageView.image = image
            }
        }.resume()
    }
    
    // MARK: - Properties
    
    var user: User? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
}
