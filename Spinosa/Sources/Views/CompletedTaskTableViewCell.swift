//
//  CompletedTaskTableViewCell.swift
//  HTTPDebugger
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Red Davis. All rights reserved.
//

import UIKit


internal final class CompletedTaskTableViewCell: UITableViewCell, Reusable
{
    // Static
    static let reuseIdentifier = #file
    
    // Internal
    internal var task: Task? {
        didSet
        {
            self.reloadData()
        }
    }
    
    // MARK: Initialization
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        self.textLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        abort()
    }
    
    // MARK: Data
    
    private func reloadData() {
        textLabel?.text = task?.requestDescription
        
        guard let statusCode = task?.statusCode, let time = task?.timestampFormatted else { return }
        let subtitle = "\(statusCode) - \(time)"
        let color = task?.isSuccess == true ? UIColor.systemGreen : UIColor.systemRed
        let range = (subtitle as NSString).range(of: "\(statusCode)")
        let styledText = NSMutableAttributedString(string: subtitle)
        styledText.addAttribute(.foregroundColor, value: color, range: range)
        detailTextLabel?.attributedText = styledText
    }
}
