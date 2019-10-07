//
//  Spinosa.swift
//  Spinosa
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import UIKit


/// Spinosa is a non-intrusive network debugging library.
public final class Spinosa
{
    // Internal
    /// Tracked tasks
    internal private(set) var tasks = [Task]()
    
    // Private
    /// Headers to mask
    private let maskedHeaders: [String]
    
    // MARK: Initialization
    
    /// Initializes a Spinosa instance.
    /// - Parameter maskedHeaders: Array of headers that should be masked.
    public required init(maskedHeaders: [String]? = nil)
    {
        self.maskedHeaders = maskedHeaders ?? []
    }
    
    // MARK: API
    
    /// Add `Data` returned from a response.
    /// - Parameter data: `Data` from a response.
    /// - Parameter request: The request that returned the response.
    public func add(_ data: Data, for request: URLRequest)
    {
        let matchedTask = self.tasks.first(where: { (task) -> Bool in
            return task.sessionTask.originalRequest == request
        })
        
        matchedTask?.responseData = data
    }
    
    /// Add metrics collected from a `URLSessionTask`.
    /// - Parameter metrics: Metrics passed from `URLSessionTaskDelegate`.
    /// - Parameter task: Task passed from `URLSessionTaskDelegate`.
    public func add(_ metrics: URLSessionTaskMetrics, for task: URLSessionTask)
    {
        let task = Task(task: task, metrics: metrics, maskedHeaders: self.maskedHeaders)
        self.tasks.insert(task, at: 0)
        
        guard self.tasks.count > 30 else { return }
        _ = self.tasks.popLast()
    }
    
    /// Saves all tracked tasks to a given directory.
    /// - Parameter url: `URL` to a directory where tracked tasks should be written to.
    public func save(to url: URL) throws -> URL
    {
        let fileManager = FileManager.default
        let exportDirectory = url.appendingPathComponent(UUID().uuidString)

        try fileManager.createDirectory(at: exportDirectory, withIntermediateDirectories: true, attributes: nil)

        for task in self.tasks
        {
            try task.write(to: exportDirectory)
        }

        return exportDirectory
    }
}
