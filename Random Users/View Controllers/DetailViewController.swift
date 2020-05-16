//
//  DetailViewController.swift
//  Random Users
//
//  Created by Jarren Campos on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var user: User? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userPhoneNumber: UILabel!
    @IBOutlet var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let user = user, isViewLoaded else { return }
        
        let name = user.name
        let first = name.first
        let last = name.last
        let fullName = "\(first.capitalized) \(last.capitalized)"
        
        userName.text = fullName
        userPhoneNumber.text = user.phone
        userEmail.text = user.email
    }
    
}
