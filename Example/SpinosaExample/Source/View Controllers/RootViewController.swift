//
//  RootViewController.swift
//  SpinosaExample
//
//  Created by Red Davis on 06/10/2019.
//  Copyright © 2019 Plum Fintech Limited. All rights reserved.
//

import SnapKit
import Spinosa
import UIKit


internal final class RootViewController: UIViewController
{
    // Private
    private let apiClient = ExampleAPIClient()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Present card button
        let presentCardButton = UIButton(type: .system)
        presentCardButton.setTitle("Present", for: .normal)
        presentCardButton.addTarget(self, action: #selector(self.presentSpinosaButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(presentCardButton)

        presentCardButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // Trigger some API requests
        for _ in 0...5
        {
            self.apiClient.fetch()
        }
    }
    
    // MARK: Actions
    
    @objc private func presentSpinosaButtonTapped(_ sender: Any)
    {
        let controller = SpinosaDebugViewController(spinosa: self.apiClient.spinosa)
        self.present(controller, animated: true, completion: nil)
    }
}
