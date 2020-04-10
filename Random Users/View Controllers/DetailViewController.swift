//
//  DetailViewController.swift
//  Random Users
//
//  Created by Karen Rodriguez on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personPhone: UILabel!
    @IBOutlet weak var personEmail: UILabel!
    
    // MARK: - Properties
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    var imageData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
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

    // MARK: - Methods
    
    private func updateViews() {
        if isViewLoaded {
            guard let person = person else { return }
            personName.text = person.fullName()
            personEmail.text = person.email
            personPhone.text = person.phone
            
            guard let data = imageData else { return }
            personImage.image = UIImage(data: data)
        }
    }
    
}
