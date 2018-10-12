//
//  Helpers.swift
//  Random Users
//
//  Created by Jason Modisett on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

// Run a thread-safe block of code in the background
public func background(_ block: @escaping () -> Void) {
    DispatchQueue.global().async(execute: block)
}

// Run a block of code relating to UI on the main thread
public func UI(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}
