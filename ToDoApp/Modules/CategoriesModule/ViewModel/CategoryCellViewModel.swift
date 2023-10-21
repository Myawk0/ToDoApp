//
//  CategoryCellViewModel.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

class CategoryCellViewModel: CategoryCellViewModelType {
    
    private var category: Category
    private var indexPath: IndexPath
    
    private let realmService = RealmCategories.shared
    
    init(category: Category, indexPath: IndexPath) {
        self.category = category
        self.indexPath = indexPath
    }
    
    var emoji: String {
        return category.emoji
    }
    
    var title: String {
        return category.title
    }
    
    var countTasks: Int {
        return category.countTasks
    }
    
    func deleteCategory() {
        realmService.deleteCategory(at: indexPath.row - 1)
    }
    
    func updateCategory(emoji: String) {
        if let category = realmService.categories?[indexPath.row - 1] {
            realmService.updateCategory(category, emoji: emoji)
        }
    }
}
