//
//  TableRow.swift
//  TableData
//
//  Created by Red Davis on 22/01/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import UIKit


internal final class TableRow
{
    // Internal
    internal typealias DequeueHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
    internal typealias SelectionHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
    internal typealias DisplayHandler = (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void
    internal typealias EditHandler = (_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void

    internal let dequeueHandler: DequeueHandler
    internal var willDisplayHandler: DisplayHandler?
    internal var didSelectHandler: SelectionHandler?
    internal var didDeselectHandler: SelectionHandler?
    internal var editHandler: EditHandler?

    internal var isEditable: Bool {
        return self.editHandler != nil
    }
    
    // MARK: Initialization
    
    internal init(dequeueHandler: @escaping DequeueHandler)
    {
        self.dequeueHandler = dequeueHandler
    }
}
