//
//  AppearanceHelper.swift
//  Random Users
//
//  Created by Kat Milton on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum AppearanceHelper {
    
    static let largeLexFont = UIFont(name: "Lexend Deca", size: 32)
    static let smallLexFont = UIFont(name: "Lexend Deca", size: 18)
    
    static let mintColor = UIColor(red: 194.0/255.0, green: 231.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    static let orangeColor = UIColor(red: 253.0/255.0, green: 80.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let pinkColor = UIColor(red: 217.0/255.0, green: 3.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    static let purpleColor = UIColor(red: 54.0/255.0, green: 5.0/255.0, blue: 104.0/255.0, alpha: 1.0)
    
    static func setUpAppearance() {
        let largeTextAttributes = [NSAttributedString.Key.font: largeLexFont!, NSAttributedString.Key.foregroundColor: pinkColor]
        let titleTextAttributes = [NSAttributedString.Key.font: smallLexFont!, NSAttributedString.Key.foregroundColor: pinkColor]
        
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = largeTextAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        UINavigationBar.appearance().barTintColor = purpleColor
        UINavigationBar.appearance().tintColor = pinkColor
        
        UITableView.appearance().backgroundColor = mintColor
        UITableViewCell.appearance().backgroundColor = mintColor
        
        
    }
    
    
    
}
