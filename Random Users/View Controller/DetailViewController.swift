//
//  DetailViewController.swift
//  Random Users
//
//  Created by Diante Lewis-Jolley on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()



    }

    private func updateViews() {

        guard let user = user else { return }

        navigationItem.title = user.name
        userNameLabel.text = user.name
        numberLabel.text = user.phoneNumber
        emailLabel.text = user.email

        let largeImageOperation = FetchLargeImageOperation(user: user)

        let operation = BlockOperation {
            guard let image = largeImageOperation.largeImage else { return }
            self.userImageView.image = image
        }

        operation.addDependency(largeImageOperation)

        photoFetchQueue.addOperation(largeImageOperation)
        OperationQueue.main.addOperation(operation)


    }

    


    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var user: User?
    let photoFetchQueue = OperationQueue()

}
