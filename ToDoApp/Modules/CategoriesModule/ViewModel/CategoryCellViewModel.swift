//
//  CategoryCellViewModel.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

class CategoryCellViewModel: CategoryCellViewModelType {
    
    // MARK: - Properties
    
    private var category: Category
    private var indexPath: IndexPath
    
    // MARK: - Realm Service Singleton
    
    private let realmService = RealmCategories.shared
    
    // MARK: - Init
    
    init(category: Category, indexPath: IndexPath) {
        self.category = category
        self.indexPath = indexPath
    }
    
    // MARK: - Category Emoji
    
    var emoji: String {
        return category.emoji
    }
    
    // MARK: - Category Title
    
    var title: String {
        return category.title
    }
    
    // MARK: - Count Tasks in specific Category
    
    var countTasks: Int {
        return category.countTasks
    }
    
    // MARK: - Delete category using Realm
    
    func deleteCategory() {
        realmService.deleteCategory(at: indexPath.row - 1)
    }
    
    // MARK: - Update Category using Realm
    
    func updateCategory(emoji: String) {
        if let category = realmService.categories?[indexPath.row - 1] {
            realmService.updateCategory(category, emoji: emoji)
        }
    }
}
