//
//  NavigationController.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import UIKit

protocol NavigationControllerDelegate: AnyObject {
    func updateData(isSearch: Bool)
}

class NavigationController: UINavigationController {
    
    var isSearchButtonTapped = false
    var realmService = RealmToDoItems.shared
    
    weak var navDelegate: NavigationControllerDelegate?
    
    var previousController: UIViewController?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        searchBar.searchTextField.rightView = clearButton
        searchBar.searchTextField.rightViewMode = .whileEditing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupAppearance()
    }
    
    func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationBar.standardAppearance = appearance
        
        navigationBar.tintColor = .darkGray
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .darkGray
        searchBar.placeholder = " Search..."
        return searchBar
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .darkGray
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var searchButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(systemItem: .search)
        barButton.target = self
        barButton.action = #selector(searchButtonTapped)
        return barButton
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(systemItem: .cancel)
        barButton.target = self
        barButton.action = #selector(cancelButtonTapped)
        return barButton
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "chevron.left")
        barButton.target = self
        barButton.action = #selector(backButtonIsTapped)
        return barButton
    }()
    
    func setupHeader(for currentController: UIViewController) {
        currentController.navigationItem.titleView = titleLabel
    
        if let current = currentController as? CategoriesViewController {
            current.navigationItem.leftBarButtonItems = []
            titleLabel.text = "Categories"
            current.navigationItem.rightBarButtonItems = []
            
        } else if let current = currentController as? ToDoListViewController {
            current.navigationItem.leftBarButtonItems = [UIBarButtonItem(), backButton]
            titleLabel.text = realmService.selectedCategory?.title ?? "ToDo Items"
            current.navigationItem.rightBarButtonItem = searchButton
        }
    }
    
    @objc func backButtonIsTapped() {
        popViewController(animated: true)
    }
    
    @objc private func clearButtonTapped() {
        searchBar.searchTextField.text = ""
        if searchBar.text?.count == 0 {
            realmService.loadTasks()
            navDelegate?.updateData(isSearch: false)
            
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
    @objc func searchButtonTapped() {
        topViewController?.navigationItem.rightBarButtonItem = cancelButton
        topViewController?.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        searchBar.searchTextField.text = ""
        //realmService.loadTasks()
        //navDelegate?.updateData(isSearch: false)
        topViewController?.navigationItem.rightBarButtonItem = searchButton
        topViewController?.navigationItem.titleView = titleLabel
    }
}

extension NavigationController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textToFind = searchBar.text {
            realmService.searchTasks(from: textToFind)
            navDelegate?.updateData(isSearch: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            realmService.loadTasks()
            navDelegate?.updateData(isSearch: false)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        setupHeader(for: viewController)
    }
}

