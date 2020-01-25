//
//  ImageDisplayHelper.swift
//  Random Users
//
//  Created by Joe on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    func displayURLImage(url: String) -> UIImage {
        let imageURL = URL(string: url)!
        let data = try? Data(contentsOf: imageURL)
        let image = UIImage(data: data!)
        return image ?? UIImage(named: "notAvailable.jpg")!
    }
}

