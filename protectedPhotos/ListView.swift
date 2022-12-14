//
//  ListView.swift
//  protectedPhotos
//
//  Created by 1234 on 05.09.2022.
//

import UIKit

final class ListView: UIView {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()

    //MARK: - LifeCicle
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        layout()
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods
    func setTable(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    func reloadTable() {
        tableView.reloadData()
    }

    private func layout() {
        [tableView].forEach { self.addSubview($0) }

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
