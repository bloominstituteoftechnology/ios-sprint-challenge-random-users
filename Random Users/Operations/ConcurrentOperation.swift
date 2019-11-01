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

class FetchPhotoOperation: ConcurrentOperation {
    
    
    var imageData: Data?
    var session: URLSession
    var dataTask: URLSessionDataTask?
    
    
    let fullName: String
    let email: String
    let phone: String
    let imageURL: URL

    init(user: User, session: URLSession = URLSession.shared) {
        
        self.fullName = "\(user.name.first) \(user.name.last)"
        self.email = user.email
        self.phone = user.phone
        self.imageURL = user.picture.thumbnail
        self.session = session
        //super.init()
    }

    override func start() {
        super.start()
        state = .isExecuting
        
        let url = imageURL
            let task = session.dataTask(with: url) { (data, response, error) in
                
                defer { self.state = .isFinished }
                if self.isCancelled { return }

                if let error = error {
                    NSLog("Error fetching image data: \(error)")
                    return
                }
                
                if let data = data {
                    self.imageData = data
                }
                
                defer { self.state = .isFinished }
                if self.isCancelled { return }

            }
            task.resume()
            dataTask? = task
        }


        override func cancel() {
            super.cancel()
            dataTask?.cancel()
        }
}
