//
//  DetailViewController.swift
//  Random Users
//
//  Created by Lydia Zhang on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
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
        // Do any additional setup after loading the view.
    }
    


}
