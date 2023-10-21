//
//  ToDoListViewModel.swift
//  ToDoApp
//
//  Created by Мявкo on 20.10.23.
//

import Foundation

class ToDoListViewModel: ToDoListViewModelType {
    
    private var realmService = RealmToDoItems.shared
    
    init() {}
    
    var numberOfRows: Int {
        return (realmService.todoItems?.count ?? 0) + 1
    }
    
    var heightOfRow: CGFloat {
        return 40
    }
    
    func loadTasks() {
        realmService.loadTasks()
    }
    
    func cellViewModel(for indexPath: IndexPath) -> ToDoItemCellViewModelType? {
        if let todoItems = realmService.todoItems {
            if todoItems.count > 0 && indexPath.row < todoItems.count {
                let item = todoItems[indexPath.row]
                return ToDoItemCellViewModel(item: item, indexPath: indexPath, isRowForNewItem: false)
            }
            else {
                return ToDoItemCellViewModel(item: nil, indexPath: indexPath, isRowForNewItem: true)
            }
        }
        return nil
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if let todoItems = realmService.todoItems {
            if indexPath.row == todoItems.count {
                realmService.addTask(with: "", index: indexPath.row)
            }
        }
    }
}
