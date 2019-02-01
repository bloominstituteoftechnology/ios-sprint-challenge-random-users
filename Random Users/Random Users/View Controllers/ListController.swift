//
//  ListController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit



//Properties
private var thumbQueue = OperationQueue() //ok
private let cache = Cache<String, Data>() //ok

//Each thumbnail download operation for each cell will live here.
private var thumbnailDownloads: [String: ThumbnailOperation] = [:] //ok

var cellImage: UIImage? = nil




