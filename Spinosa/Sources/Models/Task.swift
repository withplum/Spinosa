//
//  CompletedTask.swift
//  HTTPDebugger
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Red Davis. All rights reserved.
//

import Foundation


internal final class Task
{
    // Internal
    internal let sessionTask: URLSessionTask
    internal let metrics: URLSessionTaskMetrics
    
    internal var requestDescription: String? {
        guard let path = self.path,
              let method = self.method else
        {
            return nil
        }
        
        return "\(method.uppercased()) \(path)"
    }
    
    internal var host: String? {
        return self.sessionTask.originalRequest?.url?.host
    }
    
    internal var path: String? {
        return self.sessionTask.originalRequest?.url?.path
    }
    
    internal var method: String? {
        return self.sessionTask.originalRequest?.httpMethod
    }

    internal var requestHeaders: [String : String] {
        guard let fields = self.sessionTask.originalRequest?.allHTTPHeaderFields else
        {
            return [:]
        }
        
        return fields.reduce(into: [String : String](), { (result, keyValue) in
            let shouldMaskValue = self.maskedHeaders.contains(keyValue.key)
            result[keyValue.key] = shouldMaskValue ? "*****" : keyValue.value
        })
    }
    
    internal var responseHeaders: [String : String] {
        guard let fields = self.httpResponse?.allHeaderFields else
        {
            return [:]
        }
        
        return fields.reduce(into: [String : String](), { (result, keyValue) in
            guard let keyString = keyValue.key as? String,
                  let valueString = keyValue.value as? String else
            {
                return
            }
            
            let shouldMaskValue = self.maskedHeaders.contains(keyString)
            result[keyString] = shouldMaskValue ? "*****" : valueString
        })
    }
    
    internal var queryItems: [URLQueryItem] {
        guard let url = self.sessionTask.originalRequest?.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else
        {
            return []
        }
        
        return queryItems
    }
    
    internal var requestData: Data? {
        return self.sessionTask.originalRequest?.httpBody
    }
    
    internal var responseData: Data?
    
    internal var isSuccess: Bool {
        guard let statusCode = self.statusCode else
        {
            return false
        }
        
        return 200...299 ~= statusCode
    }
    
    internal var statusCode: Int? {
        return self.httpResponse?.statusCode
    }
    
    internal var formattedRequestData: String? {
        guard let data = self.requestData else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    internal var formattedResponseData: String? {
        guard let data = self.responseData else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // Private
    private let timestamp = Date()
    private let maskedHeaders: [String]
    
    private var httpResponse: HTTPURLResponse? {
        return self.sessionTask.response as? HTTPURLResponse
    }
    
    private var filename: String {
        let requestDescription = (self.requestDescription ?? "Unknown request").replacingOccurrences(of: "/", with: "_")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy_hh:mm:ss:SSS"
        
        return "\(requestDescription)-\(dateFormatter.string(from: self.timestamp))-\(UUID().uuidString).txt"
    }
    
    // MARK: Initialization
    
    internal init(task: URLSessionTask, metrics: URLSessionTaskMetrics, maskedHeaders: [String])
    {
        self.sessionTask = task
        self.metrics = metrics
        self.maskedHeaders = maskedHeaders
    }
    
    // MARK: Description
    
    internal func description() -> String
    {
        var description = "--- Request Overview ---\n"
        description.append("Method: \(self.method ?? "Unknown")\n")
        description.append("URL: \(self.sessionTask.originalRequest?.url?.absoluteString ?? "Unknown")\n")
        
        description.append("\n--- Request Headers ---\n")
        self.requestHeaders.forEach { (key, value) in
            description.append("\(key): \(value)\n")
        }
        
        description.append("\n--- Request Query Items ---\n")
        self.queryItems.forEach { (item) in
            description.append("\(item.name): \(item.value ?? "No Value")\n")
        }
        
        description.append("\n--- Request Body ---\n")
        description.append("\(self.formattedRequestData ?? "No Request Body")\n")
        
        description.append("\n--- Response Overview ---\n")
        description.append("Status Code: \(String(self.statusCode ?? 0))\n")
        description.append("Duration: \(String(self.metrics.taskInterval.duration))\n")
        
        description.append("\n--- Response Headers ---\n")
        self.responseHeaders.forEach { (key, value) in
            description.append("\(key): \(value)\n")
        }
        
        description.append("\n--- Response Body ---\n")
        description.append("\(self.formattedResponseData ?? "No Response Body")\n")
        
        return description
    }
    
    // MARK: Export
    
    internal func write(to directory: URL) throws
    {
        let url = directory.appendingPathComponent(self.filename)
        try self.description().write(to: url, atomically: true, encoding: .utf8)
    }
}
