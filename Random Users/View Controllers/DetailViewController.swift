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
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
   // MARK: - Methods
    func updateViews(){
        guard let user = user, isViewLoaded else {return}

        do {
            userImage.image = UIImage(data: try Data(contentsOf: user.picture))
        } catch {
            NSLog("Image Data call failed")
        }
        userName.text = user.name
        userPhone.text = user.phone
        userEmail.text = user.email
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
}
