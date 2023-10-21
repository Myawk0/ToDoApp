//
//  RealmCategories.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import RealmSwift

protocol RealmCategoriesDelegate: AnyObject {
    func insertItemInCollection(at index: Int)
    func deleteItemFromCollection(at index: Int)
}

class RealmCategories: StorageManager {
    
    static let shared = RealmCategories()
    private let realm = try! Realm()
    
    weak var delegate: RealmCategoriesDelegate?
    
    var categories: Results<Category>?
    
    func loadCategories() {
        categories = load(Category.self)
    }
    
    func addCategory(emoji: String, title: String) {
        if let count = categories?.count {
            let newCategory = Category()
            newCategory.emoji = emoji
            newCategory.title = title
            
            save(newCategory)
            loadCategories()
            
            delegate?.insertItemInCollection(at: count + 1)
        }
    }
    
    func updateCategory(_ category: Category, emoji: String) {
        do {
            try realm.write {
                category.emoji = emoji
            }
        } catch {
            print("Error updating emoji in Category, \(error)")
        }
    }
    
    func deleteCategory(at index: Int) {
        if let categoryForDeletion = categories?[index] {
            delete(categoryForDeletion)
            delegate?.deleteItemFromCollection(at: index + 1)
        }
    }
}
