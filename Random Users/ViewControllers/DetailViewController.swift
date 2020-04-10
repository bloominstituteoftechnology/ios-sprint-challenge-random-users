//
//  DetailViewController.swift
//  Random Users
//
//  Created by Bradley Diroff on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var faceBig: UIImageView!
    @IBOutlet weak var nameFace: UILabel!
    @IBOutlet weak var phoneFace: UILabel!
    @IBOutlet weak var emailFace: UILabel!
    
    var face: Face?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }

    func setupViews() {
        guard let face = face, let _ = self.nameFace.text, let _ = self.phoneFace.text, let _ = self.emailFace.text else {return}
        
        DispatchQueue.main.async {
            self.nameFace.text = face.name
            self.phoneFace.text = face.phone
            self.emailFace.text = face.email
        }
        
    }
    
    func loadPicture() {
        
    }
    
}
