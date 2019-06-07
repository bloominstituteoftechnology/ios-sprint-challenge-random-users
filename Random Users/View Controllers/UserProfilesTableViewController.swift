//
//  UserProfilesTableViewController.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserProfileTableViewController: UIViewController {
    // MARK: - Properties
    
    var users: [User] = []
    var userImages: [String : Data] = [:]
    var networkClient = NetworkClient()
    private var cache = Cache<String, User>()
    private var imageOperationQueue = OperationQueue()
    private var imageFetchOperations: [String : ImageFetchOperation] = [:]

}
