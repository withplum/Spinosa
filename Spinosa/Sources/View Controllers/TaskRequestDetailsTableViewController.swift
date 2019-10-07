//
//  TaskDetailsTableViewController.swift
//  HTTPDebugger
//
//  Created by Red Davis on 10/03/2019.
//  Copyright © 2019 Red Davis. All rights reserved.
//

import UIKit


internal final class TaskRequestDetailsTableViewController: UIViewController
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

        // Request
        var requestRows = [TableRow]()
        let host = TableRow { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell: Value1TableViewCell = tableView.dequeueReusableCell(at: indexPath)
            cell.textLabel?.text = "Host"
            cell.detailTextLabel?.text = self?.task.host

            return cell
        }
        requestRows.append(host)

        let path = TableRow { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell: Value1TableViewCell = tableView.dequeueReusableCell(at: indexPath)
            cell.textLabel?.text = "Path"
            cell.detailTextLabel?.text = self?.task.path

            return cell
        }
        requestRows.append(path)

        let method = TableRow { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell: Value1TableViewCell = tableView.dequeueReusableCell(at: indexPath)
            cell.textLabel?.text = "Method"
            cell.detailTextLabel?.text = self?.task.method

            return cell
        }
        requestRows.append(method)

        let date = TableRow { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell: Value1TableViewCell = tableView.dequeueReusableCell(at: indexPath)
            cell.textLabel?.text = "Date"
            cell.detailTextLabel?.text = self?.task.metrics.taskInterval.start.description

            return cell
        }
        requestRows.append(date)

        if let requestData = self.task.formattedRequestData
        {
            let body = TableRow { (tableView, indexPath) -> UITableViewCell in
                let cell: TableViewCell = tableView.dequeueReusableCell(at: indexPath)
                cell.textLabel?.text = "Body"
                cell.accessoryType = .disclosureIndicator

                return cell
            }

            body.didSelectHandler = { [weak self] (tableView, indexPath) in
                let viewController = TaskDataViewController(text: requestData)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }

            requestRows.append(body)
        }

        let requestSection = TableSection(rows: requestRows, header: nil, footer: nil, identifier: nil)
        sections.append(requestSection)

        // Headers
        let headerRows = self.task.requestHeaders.map { (key, value) -> TableRow in
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

        // Query items
        let queryItemRows = self.task.queryItems.map { (item) -> TableRow in
            let row = TableRow { (tableView, indexPath) -> UITableViewCell in
                let cell: Value1TableViewCell = tableView.dequeueReusableCell(at: indexPath)
                cell.textLabel?.text = item.name
                cell.detailTextLabel?.text = item.value

                return cell
            }

            row.didSelectHandler = { [weak self] (_, _) in
                guard let self = self else { return }

                UIPasteboard.general.string = "\(item.name): \(item.value ?? "No Value")"
                self.feedbackGenerator.notificationOccurred(.success)
            }

            return row
        }

        let queryItemsHeader = TableHeaderFooter { (tableView, section) -> UITableViewHeaderFooterView in
            let header: TitleSectionTableHeaderView = tableView.dequeueReusableHeaderFooterView()
            header.titleLabel.text = "QUERY ITEMS"

            return header
        }

        let queryItemsSection = TableSection(rows: queryItemRows, header: queryItemsHeader, footer: nil, identifier: nil)
        sections.append(queryItemsSection)

        // Reload data
        self.dataSource.sections = sections
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDelegate

extension TaskRequestDetailsTableViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = self.dataSource.sections[indexPath.section]
        let row = section.row(at: indexPath.row)

        row.didSelectHandler?(tableView, indexPath)
    }
}
