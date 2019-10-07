//
//  Value1TableViewCell.swift
//  Plum
//
//  Created by Red Davis on 18/01/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import UIKit


internal class Value1TableViewCell: UITableViewCell, Reusable
{
    // MARK: Initialization
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    internal required init?(coder aDecoder: NSCoder)
    {
        abort()
    }
}
