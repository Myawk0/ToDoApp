//
//  ItemsViewController.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    // MARK: - ViewModel
    
    var viewModel: ToDoListViewModelType?
    
    // MARK: - View
    
    private lazy var tableView: UITableView = _tableView
    
    var isSearch = false
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = viewModel else { return }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel?.loadTasks()
        setupNavigationBar()
        setupDelegates()
        
        addSubviews()
        applyConstraints()
    }
    
    // MARK: - Setup NavigationBar
    
    private func setupNavigationBar() {
        let navController = navigationController as! NavigationController
        navController.navDelegate = self
    }
    
    // MARK: - Setup Delegates
    
    private func setupDelegates() {
        RealmToDoItems.shared.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Subviews
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}

// MARK: - UITableViewDataSource

extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.ToDoList.reuseIdentifier, for: indexPath) as! ToDoItemCell
        
        cell.selectionStyle = .none
       
        cell.viewModel = viewModel?.cellViewModel(for: indexPath)
        cell.hideNewItemRow(if: isSearch)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        viewModel?.didSelectRow(at: indexPath)
        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ToDoItemCell {
            cell.makeNewTextFieldActive()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightOfRow ?? 40
    }
}

// MARK: - RealmToDoItemsDelegate to update UITableView

extension ToDoListViewController: RealmToDoItemsDelegate {
    
    func insertRowInTable(at index: Int) {
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteRowFromTable(at index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

// MARK: - NavigationControllerDelegate

extension ToDoListViewController: NavigationControllerDelegate {
    func updateData(isSearch: Bool) {
        self.isSearch = isSearch
        tableView.reloadData()
    }
}

// MARK: - Setup elements

private extension ToDoListViewController {
    var _tableView: UITableView {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: K.ToDoList.reuseIdentifier)
        return tableView
    }
}
