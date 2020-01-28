//
//  ConcurrentOperation.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import UIKit

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

// MARK: - FetchFriendsOperation Subclass

// Purpose of the subclass is to initiate a data task that we can put on separate queues and also cancel if needed.
class FetchFriendsOperation: ConcurrentOperation {
    var image: UIImage?
    var friend: Friend
    var networkImageTask: URLSessionTask?
    
    init(friend: Friend) {
        self.friend = friend
    }
    
    override func start() {
        state = .isExecuting
        if isCancelled {
            state = .isFinished
            return
        }
        
        // Code to fetch the thumbnail image from the server.
        let thumbnailURL = friend.thumbnail
        var requestURL = URLRequest(url: thumbnailURL)
        requestURL.httpMethod = "GET"
        
        networkImageTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            defer {
                self.state = .isFinished
            }
            if error != nil {
                print("Error in retrieving image data from FetchFriendsOperation: \(error!)")
                return
            }
            guard let imageData = data else {
                print("Bad image returned in FetchFriendsOperation: \(error!)")
                return
            }
            let image = UIImage(data: imageData)
            self.image = image
        }
        networkImageTask!.resume()
    }
    
    override func cancel() {
        networkImageTask?.cancel()
        super.cancel()
    }
}
