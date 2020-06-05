//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - IBOutlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    //MARK: -Public

    var user: Users? { didSet {
        updateViews()
        }}

    var thumbnailCache: Cache<URL, Data>? { didSet {
        updateViews()
        }}

    //MARK: -Private

    private var loadImageOp: LoadImageOperation?

    private func updateViews() {
        guard let user = user, let cache = thumbnailCache else { return }
        self.nameLabel.text = user.name.fullName
        let loadImageOperation = LoadImageOperation(url: user.picture.thumbnail, imageView: thumbnailImageView, cache: cache)
        OperationQueue.main.addOperation(loadImageOperation)
        self.loadImageOp = loadImageOperation
    }

    //MARK: - Overrides

    override func prepareForReuse() {
        loadImageOp?.cancel()
        loadImageOp = nil

        user = nil
        thumbnailCache = nil
        thumbnailImageView.image = ImageHelper.placeholder
        nameLabel.text = nil
    }
}
