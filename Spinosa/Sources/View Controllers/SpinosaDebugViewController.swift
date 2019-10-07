//
//  SpinosaDebugViewController.swift
//  Plum
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import SnapKit
import UIKit


/// Spinosa debug view controller.
public final class SpinosaDebugViewController: UIViewController
{
    // Private
    private let spinosa: Spinosa
    private let rootNavigationController: UINavigationController
    
    // MARK: Initialization
    
    /// Initializes a new `SpinosaDebugViewController` instance.
    /// - Parameter spinosa: The Spinosa instance to use to display tracked requests.
    public required init(spinosa: Spinosa)
    {
        self.spinosa = spinosa
        self.rootNavigationController = UINavigationController(rootViewController: TaskListTableViewController(tasks: self.spinosa.tasks))
        
        super.init(nibName: nil, bundle: nil)
        
        self.addChild(self.rootNavigationController)
    }
    
    public required init?(coder: NSCoder)
    {
        abort()
    }
    
    // MARK: View lifecycle
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Root navigation controller
        self.view.addSubview(self.rootNavigationController.view)
        
        self.rootNavigationController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
