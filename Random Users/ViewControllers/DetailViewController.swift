//
//  DetailViewController.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Lifecycle
    
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
