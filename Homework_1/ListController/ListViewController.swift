//
//  ViewController.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 10.06.2023.
//

import UIKit

struct MyWork {
    let titleLabel: String
}

final class ListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private let items = [
        MyWork(titleLabel: "Купить сыр"),
        MyWork(titleLabel: "Сделать пиццу"),
        MyWork(titleLabel: "Задание")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои дела"
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setupTableViewLayout()
    }
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true 
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            fatalError("Error")
        }
        cell.configure(item: items[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ListViewController: UITableViewDelegate {}
