//
//  DisplayImageOperation.swift
//  Random Users
//
//  Created by Joel Groomer on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class DisplayImageOperation: ConcurrentOperation {
    var getImageFrom: LoadImageOperation
    var displayIn: RandomUserTableViewCell
    
    init(getImageFrom: LoadImageOperation, displayIn: RandomUserTableViewCell) {
        self.getImageFrom = getImageFrom
        self.displayIn = displayIn
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        DispatchQueue.main.async {
            self.displayIn.imgThumbnail.image = self.getImageFrom.image
        }
        state = .isFinished
    }
}
