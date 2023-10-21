//
//  RealmToDoItems.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import RealmSwift

protocol RealmToDoItemsDelegate: AnyObject {
    func insertRowInTable(at index: Int)
    func deleteRowFromTable(at index: Int)
}

class RealmToDoItems: StorageManager {
    
    static let shared = RealmToDoItems()
    private let realm = try! Realm()
    
    weak var delegate: RealmToDoItemsDelegate?
    
    var todoItems: Results<ToDoItem>?
    
    var selectedCategory: Category? {
        didSet {
            loadTasks()
        }
    }
    
    func loadTasks() {
        todoItems = selectedCategory?.tasks.sorted(byKeyPath: "orderIndex", ascending: true)
    }
    
    func addTask(with text: String, index: Int) {
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    let newTask = ToDoItem()
                    newTask.task = text
                    newTask.orderIndex = index
                    
                    currentCategory.tasks.insert(newTask, at: index)
                }
            } catch {
                print("Error saving new Tasks")
            }
        }
        updateOrderIndexes()
        delegate?.insertRowInTable(at: index)
    }
    
    func updateTaskState(_ task: ToDoItem) {
        do {
            try realm.write {
                task.done.toggle()
            }
        } catch {
            print("Error saving done status in Task, \(error)")
        }
    }
    
    func updateTaskText(_ task: ToDoItem, with text: String) {
        do {
            try realm.write {
                task.task = text
            }
        } catch {
            print("Error saving updated Task text, \(error)")
        }
    }
    
    func updateOrderIndexes() {
        guard let todoItems = todoItems else { return }

        do {
            try realm.write {
                for (index, item) in todoItems.enumerated() {
                    item.orderIndex = index
                }
            }
        } catch {
            print("Error updating Order Indexes, \(error)")
        }
    }
    
    func searchTasks(from text: String) {
        todoItems = todoItems?.filter("Task CONTAINS[cd] %@", text).sorted(byKeyPath: "orderIndex", ascending: true)
    }
    
    func deleteTask(at index: Int) {
        if let itemForDeletion = todoItems?[index] {
            delete(itemForDeletion)
            updateOrderIndexes()
            loadTasks()
            delegate?.deleteRowFromTable(at: index)
        }
    }
}
