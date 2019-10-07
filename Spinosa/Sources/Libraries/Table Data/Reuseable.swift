//
//  Reuseable.swift
//  Red Davis
//
//  Created by Red Davis on 02/11/2016.
//  Copyright © 2016 Red Davis. All rights reserved.
//

import UIKit


internal protocol Reusable: class
{
    static var reuseIdentifier: String { get }
}

internal extension Reusable
{
    static var reuseIdentifier: String { return String(describing: Self.self) }
}


// MARK: UITableView

internal extension UITableView
{
    func register<T: UITableViewCell>(reusableCell: T.Type) where T: Reusable
    {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(at indexPath: IndexPath) -> T where T: Reusable
    {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(view: T.Type) where T: Reusable
    {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable
    {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}
