//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Joel Groomer on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var user: User? { didSet { updateViews() } }
    var loadOp: LoadImageOperation?
    var displayOp: DisplayImageOperation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func updateViews() {
        guard let user = user else { return }
        
        lblName.text = ("\(user.firstName) \(user.lastName)")
        loadOp = LoadImageOperation(url: user.thumbnail)
        guard let loadOp = loadOp else { return }
        displayOp = DisplayImageOperation(getImageFrom: loadOp, displayIn: self)
        guard let displayOp = displayOp else { return }
        displayOp.addDependency(loadOp)
        let queue = OperationQueue()
        queue.addOperations([loadOp, displayOp], waitUntilFinished: false)
    }
    
    override func prepareForReuse() {
        guard let loadOp = loadOp, let displayOp = displayOp else { return }
        loadOp.cancel()
        displayOp.cancel()
    }

}
