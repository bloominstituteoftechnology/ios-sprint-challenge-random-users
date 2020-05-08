//
//  ConcurrentOperation.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class ConcurrentOperation: Operation {
    
    // MARK: Types
    
    enum State: String {
        case isReady, isExecuting, isFinished
    }
    
    // MARK: Properties
    
    private var _state = State.isReady
    
    private let stateQueue = DispatchQueue(label: "com.LambdaSchool.Astronomy.ConcurrentOperationStateQueue")
    var state: State {
        get {
            var result: State?
            let queue = self.stateQueue
            queue.sync {
                result = _state
            }
            return result!
        }
        
        set {
            let oldValue = state
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: oldValue.rawValue)
            
            stateQueue.sync { self._state = newValue }
            
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: newValue.rawValue)
        }
    }
    
    // MARK: NSOperation
    
    override dynamic var isReady: Bool {
        return super.isReady && state == .isReady
    }
    
    override dynamic var isExecuting: Bool {
        return state == .isExecuting
    }
    
    override dynamic var isFinished: Bool {
        return state == .isFinished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
}

class FetchUserOperation: ConcurrentOperation {

    let photo: Picture

    private (set) var imageData: Data?  // made this a setter.

    // set these up to simplify the start and cancel functions.
    private let session: URLSession  // get the URL for that pic
    private var dataTask: URLSessionDataTask? // look for some data

    init(photo: Picture, session: URLSession = URLSession.shared) {
        self.photo = photo
        self.session = session
        super.init()
    }

    override func start() {
        state = .isExecuting
        guard let imageURL = photo.thumbnail.usingHTTPS else { return } // pulled from Picture struct and added the secure URL.
        let task = session.dataTask(with: imageURL) { (data, _, error) in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Error fetching data for \(self.photo), \(error)")
            }
            guard let data = data else { return }
            self.imageData = data
        }
        task.resume()

    }

    override func cancel() {
        dataTask?.cancel()
    }
}
