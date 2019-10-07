//
//  TaskResponseDetailsTableViewController.swift
//  Plum
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Plum. All rights reserved.
//

import UIKit


internal final class TaskResponseDetailsTableViewController: UIViewController
{
    // Private
    private let tableView: UITableView = {
        let view: UITableView
        
        if #available(iOS 13.0, *)
        {
            view = UITableView(frame: .zero, style: .insetGrouped)
        }
        else
        {
            view = UITableView(frame: .zero, style: .grouped)
        }
        
        view.tableFooterView = UIView()
        view.register(reusableCell: Value1TableViewCell.self)
        view.register(reusableCell: TableViewCell.self)
        view.registerHeaderFooterView(view: TitleSectionTableHeaderView.self)

        return view
    }()

    private let task: Task
    private let dataSource = TableDataSource()
    private let feedbackGenerator = UINotificationFeedbackGenerator()

    // MARK: Initialization

    internal required init(task: Task)
    {
        self.task = task
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

        // Table view
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.buildTableData()
    }

    // MARK: Data

    private func buildTableData()
    {
        var sections = [TableSection]()

        // Stats
        var overviewRows = [TableRow]()
        let responseTime = TableRow { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell: Value1TableViewCell = tableView.dequeueReusableCell(at: indexPath)
            cell.textLabel?.text = "Response Time"
            cell.detailTextLabel?.text = String(self?.task.metrics.taskInterval.duration ?? 0.0)

            return cell
        }
        overviewRows.append(responseTime)

        if let data = self.task.formattedResponseData
        {
            let body = TableRow { (tableView, indexPath) -> UITableViewCell in
                let cell: TableViewCell = tableView.dequeueReusableCell(at: indexPath)
                cell.textLabel?.text = "Body"
                cell.accessoryType = .disclosureIndicator

                return cell
            }

            body.didSelectHandler = { [weak self] (tableView, indexPath) in
                let viewController = TaskDataViewController(text: data)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }

            overviewRows.append(body)
        }

        let overviewSection = TableSection(rows: overviewRows, header: nil, footer: nil, identifier: nil)
        sections.append(overviewSection)

        // Headers
        let headerRows = self.task.responseHeaders.map { (key, value) -> TableRow in
            let row = TableRow { (tableView, indexPath) -> UITableViewCell in
                let cell: Value1TableViewCell = tableView.dequeueReusableCell(at: indexPath)
                cell.textLabel?.text = key
                cell.detailTextLabel?.text = value

                return cell
            }

            row.didSelectHandler = { [weak self] (_, _) in
                guard let self = self else { return }

                UIPasteboard.general.string = "\(key): \(value)"
                self.feedbackGenerator.notificationOccurred(.success)
            }

            return row
        }

        let headersHeader = TableHeaderFooter { (tableView, section) -> UITableViewHeaderFooterView in
            let header: TitleSectionTableHeaderView = tableView.dequeueReusableHeaderFooterView()
            header.titleLabel.text = "HEADERS"

            return header
        }

        let headersSection = TableSection(rows: headerRows, header: headersHeader, footer: nil, identifier: nil)
        sections.append(headersSection)

        // Reload data
        self.dataSource.sections = sections
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDelegate

extension TaskResponseDetailsTableViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = self.dataSource.sections[indexPath.section]
        let row = section.row(at: indexPath.row)

        row.didSelectHandler?(tableView, indexPath)
    }
}
