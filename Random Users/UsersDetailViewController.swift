//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_241 on 8/1/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var result: Result?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()

        
        // Do any additional setup after loading the view.
    }
    
    private func updateViews(){
        guard let res = result else { return }
        guard let img = image else { return }
        
        nameLabel.text = res.name.first + res.name.last
        emailLabel.text = res.email
        numberLabel.text = res.phone
        imageView.image = img
        
        
        
    
        
        
        
    }


}
