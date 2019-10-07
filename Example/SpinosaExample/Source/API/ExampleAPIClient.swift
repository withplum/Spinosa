//
//  ExampleAPIClient.swift
//  SpinosaExample
//
//  Created by Red Davis on 06/10/2019.
//  Copyright © 2019 Plum Fintech Limited. All rights reserved.
//

import Foundation
import Spinosa


internal final class ExampleAPIClient: NSObject
{
    // Internal
    internal let spinosa = Spinosa(maskedHeaders: ["Authorization"])
    
    // Private
    private var session: URLSession!
    
    // MARK: Initialization
    
    internal override init()
    {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
}

// MARK: An API request

internal extension ExampleAPIClient
{
    func fetch()
    {
        let url = URL(string: "https://gist.githubusercontent.com/reddavis/f343b552b41f901e556aac118526d1b9/raw/a4f0cea3fde0350e99330f4f3f967b411c864f69/spinosa.json")!
        let request = URLRequest(url: url)
        
        let task = self.session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            // Debugger
            if let data = data
            {
                self.spinosa.add(data, for: request)
            }
        }
        
        task.resume()
    }
}

// MARK: URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate

extension ExampleAPIClient: URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate
{
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)
    {
        self.spinosa.add(metrics, for: task)
    }
}
