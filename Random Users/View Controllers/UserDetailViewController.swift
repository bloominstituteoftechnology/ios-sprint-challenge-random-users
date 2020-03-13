//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Enrique Gongora on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Variables
    var cache = Cache<String, Data>()
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        loadLargeImage()
    }
    
    // MARK: - Functions
    func updateViews() {
        guard let user = user else { return }
        userNameLabel.text = user.name
        userPhoneLabel.text = user.phone
        userEmailLabel.text = user.email
        
    }
    
    func loadLargeImage() {
        guard let user = user else { return }
        let key = user.name
        let largeURL = user.largeImage
        let request = URLRequest(url: largeURL)
        
        if let cachedData = cache.largeValue(for: key) {
            let image = UIImage(data: cachedData)
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        } else {
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching large image: \(error)")
                    return
                }
                
                guard let data = data else {
                    NSLog("No data")
                    return
                }
                self.cache.largeCache(value: data, for: key)
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
