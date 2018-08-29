//
//  URLSessionExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension URLSession {
    func sendSynchronousRequest(request: URL) -> (Data?, URLResponse?, Error?) {
        let semaphore = DispatchSemaphore(value: 0)
        var data:Data?
        var response:URLResponse?
        var error:Error?
        
        let task = self.dataTask(with: request) { (d, r, e) in
            data = d
            response = r
            error = e
            semaphore.signal()
        }
        task.resume()
        let _ = semaphore.wait(timeout: .distantFuture)
        return (data, response, error)
    }
}
