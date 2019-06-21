//
//  DetailViewController.swift
//  Random Users
//
//  Created by John Pitts on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateViews()
    }
    
        private func updateViews() {
            
            guard isViewLoaded,
            let user = user else {return}
            // insert values from Users to
            // detailImageView = .UIImage(from: data)
            detailNameLabel.text = user.name
            detailPhoneLabel.text = user.phone
            detailEmailLabel.text = user.email
        
        }
    
    func GetImage(user: User) {
        // download ONE image
    }
    
    

    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailPhoneLabel: UILabel!
    @IBOutlet weak var detailEmailLabel: UILabel!
    
    //MARK: PROPERTIES
    
    var userController: UserController?
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
}
