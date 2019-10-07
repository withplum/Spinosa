//
//  TaskData.swift
//  Plum
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import Foundation


internal struct TaskData
{
    // Internal
    internal let request: URLRequest
    internal let data: Data
    
    // MARK: Initialization
    
    internal init(request: URLRequest, data: Data)
    {
        self.request = request
        self.data = data
    }
}
