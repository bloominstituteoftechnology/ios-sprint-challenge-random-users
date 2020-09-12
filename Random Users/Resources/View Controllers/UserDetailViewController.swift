//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by John McCants on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    var contact: Contact?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
