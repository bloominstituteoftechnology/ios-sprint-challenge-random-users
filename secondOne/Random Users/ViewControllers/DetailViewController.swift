//
//  DetailViewController.swift
//  Random Users
//
//  Created by Bradley Diroff on 5/8/20.
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
        
        loadPicture(face)
        
    }
    
    func loadPicture(_ face: Face) {
        let url = URL(string: face.picture)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                NSLog("There was an error: \(error)")
                return
            }
            if let data = data, let theImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.faceBig.image = theImage
                }
            }
            
        }
        task.resume()
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
