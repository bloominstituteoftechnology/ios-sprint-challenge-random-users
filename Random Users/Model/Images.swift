//
//  Images.swift
//  Random Users
//
//  Created by Marissa Gonzales on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Images: Decodable {
    let largeImage: URL
    let mediumImage: URL
    let thumbnail: URL
}
