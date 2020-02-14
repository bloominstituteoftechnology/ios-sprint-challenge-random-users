//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    //=======================
    // MARK: - Properties
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        print(String(describing: user?.fname))
    }
    
}
