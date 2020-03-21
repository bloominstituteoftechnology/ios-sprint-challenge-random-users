//
//  User.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String = ""// nested keyed container
    var email: String
    var phone: String
    var picture: URL // nested keyed container for large, medium, and thumbnail images
         
    enum UserTopLevelKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum UserNameLevelKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureLevelKeys: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        let jsonContainer = try decoder.container(keyedBy: UserTopLevelKeys.self)
            
        let nameLevelContainer = try jsonContainer.nestedContainer(keyedBy: UserTopLevelKeys.UserNameLevelKeys.self, forKey: .name)
        
//        let topLevelContainer = try jsonContainer.nestedContainer(keyedBy: UserResultLevelKeys.UserTopLevelKeys.self, forKey: .results)
//        let nameLevelContainer = try topLevelContainer.nestedContainer(keyedBy: UserResultLevelKeys.UserTopLevelKeys.UserNameLevelKeys.self, forKey: .name)
        let title = try nameLevelContainer.decode(String.self, forKey: .title)
        let first = try nameLevelContainer.decode(String.self, forKey: .first)
        let last = try nameLevelContainer.decode(String.self, forKey: .last)
        
        self.name = "\(title) \(first) \(last)"
        
        self.email = try jsonContainer.decode(String.self, forKey: .email)
        self.phone = try jsonContainer.decode(String.self, forKey: .phone)
        
        let pictureLevelContainer = try jsonContainer.nestedContainer(keyedBy:
            UserTopLevelKeys.PictureLevelKeys.self, forKey: .picture)
        self.picture = try pictureLevelContainer.decode(URL.self, forKey: .large)
    }
}
/*
{
  "results": [
    {
      "gender": "male",
      "name": {
        "title": "mr",
        "first": "brad",
        "last": "gibson"
      },
      "location": {
        "street": "9278 new road",
        "city": "kilcoole",
        "state": "waterford",
        "postcode": "93027",
        "coordinates": {
          "latitude": "20.9267",
          "longitude": "-7.9310"
        },
        "timezone": {
          "offset": "-3:30",
          "description": "Newfoundland"
        }
      },
      "email": "brad.gibson@example.com",
      "login": {
        "uuid": "155e77ee-ba6d-486f-95ce-0e0c0fb4b919",
        "username": "silverswan131",
        "password": "firewall",
        "salt": "TQA1Gz7x",
        "md5": "dc523cb313b63dfe5be2140b0c05b3bc",
        "sha1": "7a4aa07d1bedcc6bcf4b7f8856643492c191540d",
        "sha256": "74364e96174afa7d17ee52dd2c9c7a4651fe1254f471a78bda0190135dcd3480"
      },
      "dob": {
        "date": "1993-07-20T09:44:18.674Z",
        "age": 26
      },
      "registered": {
        "date": "2002-05-21T10:59:49.966Z",
        "age": 17
      },
      "phone": "011-962-7516",
      "cell": "081-454-0666",
      "id": {
        "name": "PPS",
        "value": "0390511T"
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/men/75.jpg",
        "medium": "https://randomuser.me/api/portraits/med/men/75.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/75.jpg"
      },
      "nat": "IE"
    }
  ],
  "info": {
    "seed": "fea8be3e64777240",
    "results": 1,
    "page": 1,
    "version": "1.3"
  }
}
*/
