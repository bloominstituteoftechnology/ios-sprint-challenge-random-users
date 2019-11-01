//
//  DetailViewController.swift
//  Random Users
//
//  Created by Jesse Ruiz on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var randomUsers: RandomUsers?
    
    // MARK: - Outlets
    @IBOutlet weak var userLargeImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dobAge: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        
    }

}
