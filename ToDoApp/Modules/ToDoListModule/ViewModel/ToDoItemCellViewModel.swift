//
//  ToDoItemCellViewModel.swift
//  ToDoApp
//
//  Created by Мявкo on 21.10.23.
//

import UIKit

class ToDoItemCellViewModel: ToDoItemCellViewModelType {
    
    var indexPath: IndexPath
    private var item: ToDoItem?
    
    var isNewItemRow: Bool
    var isItemForDeletion = false
    
    var realmService = RealmToDoItems.shared
    
    init(item: ToDoItem?, indexPath: IndexPath, isRowForNewItem: Bool) {
        self.item = item
        self.indexPath = indexPath
        self.isNewItemRow = isRowForNewItem
    }
    
    var text: String {
        return item?.task ?? ""
    }
    
    var isSelected: Bool {
        return item?.done ?? false
    }
    
    func updateTextAttributes(text: String, toCrossOut: Bool) -> NSAttributedString {
        var attributedString = NSAttributedString(string: text)
        
        if toCrossOut {
            attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        }
      
        return attributedString
    }
    
    func updateDoneState() {
        if let item = realmService.todoItems?[indexPath.row] {
            realmService.updateTaskState(item)
        }
    }
    
    func taskIsWrittenInTextField(with text: String) {
        if let todoItems = realmService.todoItems, indexPath.row < todoItems.count {
            
            if !isItemForDeletion {
                let item = todoItems[indexPath.row]
                realmService.updateTaskText(item, with: text)
            }
            isItemForDeletion = false
        }
    }
    
    func taskToDelete() {
        isItemForDeletion = true
        realmService.deleteTask(at: indexPath.row)
    }
    
    func textFieldReturnButtonTapped(with task: String) -> Int {
        if let item = realmService.todoItems?[indexPath.row] {
            realmService.updateTaskText(item, with: task)
            realmService.addTask(with: "", index: indexPath.row + 1)
        }
        return indexPath.row + 1
    }
}
