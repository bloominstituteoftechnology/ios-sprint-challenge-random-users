//
//  UserImporter.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserImporter {
    
    
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)
    
    var request = URLRequest(url: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")

}
