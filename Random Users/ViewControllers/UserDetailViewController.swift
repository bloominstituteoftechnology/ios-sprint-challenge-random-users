//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jerrick Warren on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    var user: User? {
        didSet{
            updateViews()
        }
    }
    
    private func updateViews() {
        
        guard isViewLoaded,
            let user = user else { return }
        
        title = user.name
        
        let imageURL = user.fullSizeURL
        loadUserPhoto(from: imageURL)
        
        userNameLabel.text = user.name
        userPhoneLabel.text = user.phone
        userEmailLabel.text = user.email
    }
    
    private func loadUserPhoto(from imageURL: URL) {
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned. Please check URL.")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
            
            }.resume()
    }
    
  

    // MARK: - Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    
    
}
