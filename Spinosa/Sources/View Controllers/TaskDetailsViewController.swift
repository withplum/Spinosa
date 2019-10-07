//
//  TaskDetailsViewController.swift
//  Plum
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import UIKit


internal final class TaskDetailsViewController: UIViewController
{
    // Private
    private let task: Task
    private let requestViewController: TaskRequestDetailsTableViewController
    private let responseViewController: TaskResponseDetailsTableViewController

    private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Request", "Response"])
        view.selectedSegmentIndex = Segment.request.rawValue
        
        return view
    }()

    // MARK: Initialization

    internal required init(task: Task)
    {
        self.task = task
        self.requestViewController = TaskRequestDetailsTableViewController(task: task)
        self.responseViewController = TaskResponseDetailsTableViewController(task: task)

        super.init(nibName: nil, bundle: nil)

        self.addChild(self.requestViewController)
        self.addChild(self.responseViewController)
    }

    required init?(coder aDecoder: NSCoder)
    {
        abort()
    }

    // MARK: View lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *)
        {
            self.view.backgroundColor = .systemBackground
        }
        else
        {
            self.view.backgroundColor = .white
        }
        
        // Navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareButtonTapped(_:)))

        // Segmented control
        self.segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(self.segmentedControl)

        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(8.0)
            make.left.equalToSuperview().inset(8.0)
            make.right.equalToSuperview().inset(8.0)
        }

        // Request view controller
        self.view.addSubview(self.requestViewController.view)

        self.requestViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(8.0)
        }

        // Response view controller
        self.responseViewController.view.isHidden = true
        self.view.addSubview(self.responseViewController.view)

        self.responseViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(8.0)
        }
    }

    // MARK: Actions

    @objc private func shareButtonTapped(_ sender: Any)
    {
        let controller = UIActivityViewController(activityItems: [self.task.description()], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }

    @objc private func segmentedControlValueChanged(_ sender: Any)
    {
        guard let segment = Segment(rawValue: self.segmentedControl.selectedSegmentIndex) else { return }
        
        switch segment
        {
        case .request:
            self.requestViewController.view.isHidden = false
            self.responseViewController.view.isHidden = true
        case .response:
            self.requestViewController.view.isHidden = true
            self.responseViewController.view.isHidden = false
        }
    }
}



// MARK: Segment

fileprivate extension TaskDetailsViewController
{
    enum Segment: Int
    {
        case request
        case response
    }
}
