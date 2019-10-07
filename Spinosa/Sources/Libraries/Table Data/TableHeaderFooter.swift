//
//  TableHeaderFooter.swift
//  TableData
//
//  Created by Red Davis on 22/01/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import UIKit


internal struct TableHeaderFooter
{
    // Internal
    internal typealias PreparationHandler = (_ tableView: UITableView, _ section: Int) -> UITableViewHeaderFooterView
    internal let preparationHandler: PreparationHandler
    
    // MARK: Initialization
    
    internal init(preparationHandler: @escaping PreparationHandler)
    {
        self.preparationHandler = preparationHandler
    }
}
