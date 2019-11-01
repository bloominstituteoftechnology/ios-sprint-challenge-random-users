//
//  DetailViewController.swift
//  Random Users
//
//  Created by Jonalynn Masters on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageViewContainer: UIView!
    
    //MARK: Properties
    var userClient: UserClient?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.image = nil
        updateViews()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateViews() {
        loadViewIfNeeded()
        if let user = user {
            nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
            phoneLabel.text = "\(user.phone)"
            emailLabel.text = "\(user.email)"
            
            URLSession.shared.dataTask(with: user.picture.large) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching photo: \(error)")
                    return
                }
                
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
