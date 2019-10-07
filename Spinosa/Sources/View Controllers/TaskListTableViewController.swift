//
//  CompletedTaskListTableViewController.swift
//  HTTPDebugger
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Red Davis. All rights reserved.
//

import UIKit


internal final class TaskListTableViewController: UITableViewController
{
    // Private
    private let tasks: [Task]

    // MARK: Initialization

    internal required init(tasks: [Task])
    {
        self.tasks = tasks
        
        if #available(iOS 13.0, *)
        {
            super.init(style: .insetGrouped)
        }
        else
        {
            super.init(style: .plain)
        }
        
        self.title = "Requests"
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        abort()
    }

    // MARK: View lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Navigation bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeButtonTapped(_:)))

        // Tableview
        self.tableView.register(reusableCell: CompletedTaskTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }

    // MARK: Actions

    @objc private func closeButtonTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension TaskListTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CompletedTaskTableViewCell = tableView.dequeueReusableCell(at: indexPath)
        cell.task = self.tasks[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44.0
    }
}

// MARK: UITableViewDelegate

extension TaskListTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        let task = self.tasks[indexPath.row]
        let controller = TaskDetailsViewController(task: task)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
}
