//
//  ContactController.swift
//  Random Users
//
//  Created by BrysonSaclausa on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

//APIController


class ContactController {

    var myContacts: Contact?
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    enum URLMethods: String {
        case get = "GET"

    }
    enum NetworkError: Error {
        case noData
        case noImageData
        case noDecode
        case downloadError
    }
    
    
    func fetchContacts() -> Void {
        //do work
    }
    
    func fetchImage() -> Void {
        //do work
    }
    
    
    
}
