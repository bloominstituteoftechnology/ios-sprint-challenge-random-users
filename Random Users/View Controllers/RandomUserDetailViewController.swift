//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Moin Uddin on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadImage() {
        guard let user = user else { return }
        if let imageData = cache?.value(for: user.email ) {
            print("Large Image Used From Cache")
            self.userImageView.image = UIImage(data: imageData)
        } else {
            loadRandomUserImage()
        }
    }
    
    func loadRandomUserImage(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let user = user else { return }
        URLSession.shared.dataTask(with: user.largeImageUrl) { (data, _, error) in
            if let error = error {
                NSLog("Error getting Image \(error)")
                completion(error)
                return
            }

            guard let data =  data else {
                NSLog("Error returning data \(error)")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(data: data)
            }
            completion(nil)
        }.resume()
    }
    
    func updateViews() {

        guard let user = user else { return }
        loadImage()
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        phoneLabel.text = user.phoneNumber
        emailLabel.text = user.email
    }
    
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    var cache: Cache<String, Data>?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    

}
