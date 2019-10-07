//
//  TableRowData.swift
//  Red Davis
//
//  Created by Red Davis on 10/11/2016.
//  Copyright © 2016 Red Davis. All rights reserved.
//

import UIKit


// MARK: TableSection

internal struct TableSection
{
    // Internal
    internal let identifier: String?
    internal let header: TableHeaderFooter?
    internal let footer: TableHeaderFooter?
    
    internal var numberOfRows: Int {
        return self.rows.count
    }
    
    internal var containsHeader: Bool {
        return self.header != nil
    }
    
    internal var containsFooter: Bool {
        return self.footer != nil
    }
    
    // Private
    private let rows: [TableRow]
    
    // MARK: Initialization
    
    internal init(rows: [TableRow] = [], header: TableHeaderFooter? = nil, footer: TableHeaderFooter? = nil, identifier: String? = nil)
    {
        self.rows = rows
        self.header = header
        self.footer = footer
        self.identifier = identifier
    }
    
    // MARK: Rows
    
    internal func row(at index: Int) -> TableRow
    {
        return self.rows[index]
    }
}

// MARK: Equatable

extension TableSection: Equatable
{
    static func ==(lhs: TableSection, rhs: TableSection) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
}
