//  ViewController.swift
//  Homework_1
//  Created by Хасан Магомедов on 10.06.2023.

import UIKit
import FileCache

final class ListViewController: UIViewController {
    
    private let fileCache = FileCache()
    
    private var items: [ToDoItem] {
        Array(fileCache.values.values).sorted{ $0.creationDate < $1.creationDate }
    }
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.register(NewTitleTableViewCell.self, forCellReuseIdentifier: NewTitleTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.rowHeight = 56
        return tableView
    }()
    
    private let detailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus"), for: .normal)
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои дела"
        view.backgroundColor = UIColor(named: "backgroundColor")
        tableView.dataSource = self
        tableView.delegate = self
        setupLayout()
    }
    
    // MARK: - Private methods
    private func setupLayout() {
        actions()
        setupTableViewLayout()
        setupDetailsButtonLayout()
    }
    
    private func actions() {
        detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchDown)
    }
    
    @objc
    private func detailsButtonTapped() {
        let vc = DetailsViewController()
        present(vc, animated: true)
    }
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true 
    }
    
    private func setupDetailsButtonLayout() {
        view.addSubview(detailsButton)
        
        detailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
//    private func handleAdd(item: ToDoItem) {
//        fileCache.addValue(value: item)
//        tableView.reloadData()
//    }
}

// MARK: - Extension DataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.values.values.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == fileCache.values.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTitleTableViewCell.identifier, for: indexPath) as? NewTitleTableViewCell else {
                fatalError("Error")
            }
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
                fatalError("Error")
            }
            cell.accessoryType = .disclosureIndicator
            cell.configure(item: Array(fileCache.values.values)[indexPath.item])
            cell.selectionStyle = .none
            return cell
        }
    }
}

 // MARK: - Extension Delegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.fileCache.removeValue(idValue: self.items[indexPath.row].id)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        let detailButtonAction = UIContextualAction(style: .destructive, title: "Detail") { _, _, _ in
            let vc = DetailsViewController()
            self.present(vc, animated: true)
        }
        detailButtonAction.image = UIImage(named: "disclore")
        detailButtonAction.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction, detailButtonAction])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
            print("")
        }
        doneAction.image = UIImage(named: "done")
        doneAction.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)
        
        let swipe = UISwipeActionsConfiguration(actions: [doneAction])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ListHeaderView()
        return view
    }
}

extension ListViewController: DetailsViewControllerDelegate {
    
    func handleAdd(item: ToDoItem) {
        fileCache.addValue(value: item)
        tableView.reloadData()
    }
}
