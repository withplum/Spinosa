//
//  TaskMetrics.swift
//  Plum
//
//  Created by Red Davis on 11/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import Foundation


internal struct TaskMetrics
{
    // Internal
    internal let task: URLSessionTask
    internal let metrics: URLSessionTaskMetrics
    
    // MARK: Initialization
    
    internal init(task: URLSessionTask, metrics: URLSessionTaskMetrics)
    {
        self.task = task
        self.metrics = metrics
    }
}
