//
//  Utilities.swift
//  Random Users
//
//  Created by Angel Buenrostro on 3/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
