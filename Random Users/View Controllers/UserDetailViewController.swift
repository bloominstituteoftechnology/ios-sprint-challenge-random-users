//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    //MARK: -IBOutlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!

    //MARK: -Private

    private func updateViews() {
        guard let user = user, let cache = imageCache else { return }
        imageView.image = ImageHelper.placeholder
        nameLabel.text = user.name.fullName
        phoneNumberLabel.text = user.phone
        emailLabel.text = user.email

        let loadImageOperation = LoadImageOperation(url: user.picture.large, imageView: imageView, cache: cache)
        OperationQueue.main.addOperation(loadImageOperation)
        self.loadImageOperation = loadImageOperation
    }

    private weak var loadImageOperation: LoadImageOperation?

    //MARK: - Public

    var user: Users?
    var imageCache: Cache<URL, Data>?

    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loadImageOperation?.cancel()
    }
}
