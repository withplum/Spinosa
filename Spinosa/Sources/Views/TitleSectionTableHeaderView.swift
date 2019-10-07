//
//  BankTableHeaderView.swift
//  Plum
//
//  Created by Red Davis on 16/01/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import UIKit


internal final class TitleSectionTableHeaderView: UITableViewHeaderFooterView, Reusable
{
    // Internal
    internal let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        view.textColor = UIColor.systemGray
        
        return view
    }()
    
    // MARK: Initialization
    
    internal override init(reuseIdentifier: String?)
    {
        super.init(reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 13.0, *)
        {
            self.contentView.backgroundColor = .systemBackground
        }
        else
        {
            self.contentView.backgroundColor = .white
        }
        
        // Container
        let container = UIView()
        self.contentView.addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().priority(999)
            make.height.equalTo(80.0)
        }
        
        // Title label
        container.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(8.0)
            make.left.equalToSuperview().inset(16.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        abort()
    }
}
