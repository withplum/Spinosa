//
//  TaskDataViewController.swift
//  Plum
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import UIKit


internal final class TaskDataViewController: UIViewController
{
    // Private
    private let textView: UITextView = {
        let view = UITextView()
        view.alwaysBounceVertical = true

        return view
    }()

    // MARK: Initialization

    internal required init(text: String)
    {
        self.textView.text = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder)
    {
        abort()
    }

    // MARK: View lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Text view
        self.view.addSubview(self.textView)

        self.textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
