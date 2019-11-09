//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Joel Groomer on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var user: User? { didSet { updateViews() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func updateViews() {
        guard let user = user else { return }
        
        lblName.text = ("\(user.firstName) \(user.lastName)")
    }

}
