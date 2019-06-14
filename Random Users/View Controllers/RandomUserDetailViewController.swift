//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {
    
    // MARK: - Properties and Outlets
    var randomUserController: RandomUserController?
    var randomUser: RandomUser? {
        didSet {
            updateViews()
        }
    }
    private let randomUserFetchQueue = OperationQueue()
    private var activeOps: [String: FetchLargeImageOp] = [:]
    private var largeImageCache: Cache<String, UIImage> = Cache()

    @IBOutlet weak var randomImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - View Loading Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let randomUser = randomUser else { return }
        activeOps[randomUser.phone]?.cancel()
    }
    
    private func updateViews() {
        guard let randomUser = randomUser else { return }
        
        nameLabel.text = randomUser.name
        phoneLabel.text = randomUser.phone
        emailLabel.text = randomUser.email
    }
    
    private func loadImage(for randomUser: RandomUser) {
        
    }
}
