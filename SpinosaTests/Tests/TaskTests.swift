//
//  SpinosaTests.swift
//  Spinosa
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import XCTest
@testable import Spinosa


final class TaskTests: XCTestCase
{
    // MARK: Setup
    
    override class func setUp()
    {
        
    }
    
    // MARK: Tests
    
    func testInitialization()
    {
        let url = URL(string: "https://withplum.com/hello?item_one=value_one")!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization" : "confidential", "TestHeaderKey" : "TestHeaderValue"]
        
        let sessionTask = SpinosaURLSessionTask(request: request)
        let metrics = URLSessionTaskMetrics()
        let task = Task(task: sessionTask, metrics: metrics, maskedHeaders: ["Authorization"])
        
        XCTAssertEqual(task.method, request.httpMethod)
        XCTAssertEqual(task.path, url.path)
        XCTAssertEqual(task.requestDescription, "GET /hello")
        XCTAssertEqual(task.queryItems.count, 1)
        XCTAssertNotEqual(task.requestHeaders["Authorization"], "confidential")
        XCTAssertEqual(task.requestHeaders["TestHeaderKey"], "TestHeaderValue")
    }
}


// MARK: SpinosaURLSessionTask

fileprivate class SpinosaURLSessionTask: URLSessionTask
{
    // Fileprivate
    override var currentRequest: URLRequest? {
        return self._request
    }
    
    override var originalRequest: URLRequest? {
        return self._request
    }
    
    // Private
    private let _request: URLRequest
    
    // MARK: Initialization
    
    fileprivate init(request: URLRequest)
    {
        self._request = request
    }
}
