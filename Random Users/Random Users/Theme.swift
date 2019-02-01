//
//  Theme.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit

enum Theme {
    
    static let pink = UIColor(red: 150/255, green: 24/255, blue: 231/255, alpha: 1.0)
    
    static func applyTheme() {
        UINavigationBar.appearance().backgroundColor = Theme.pink 
    }
}
