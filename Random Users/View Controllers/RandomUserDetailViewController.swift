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
    
    func loadRandomUserImage(imageURL: URL, completion: @escaping (Error?) -> Void = { _ in }) {
                URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
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
        loadRandomUserImage(imageURL: user.largeImageUrl)
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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    

}
