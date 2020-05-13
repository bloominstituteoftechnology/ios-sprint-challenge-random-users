//
//  DetailViewController.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded,
            let user = user else { return }
        title = user.name
        userEmailLabel.text = user.email
        phoneNumberLabel.text = user.phone
        guard let imageData = try? Data(contentsOf: user.large!) else { fatalError() }
        userImageView.image = UIImage(data: imageData)
    }
}
