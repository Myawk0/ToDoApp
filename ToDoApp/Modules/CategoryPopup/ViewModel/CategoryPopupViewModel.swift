//
//  CategoryPopupViewModel.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

class CategoryPopupViewModel: CategoryPopupViewModelType {
    
    // MARK: - Realm service singleton
    
    private let realmService = RealmCategories.shared
    
    // MARK: - Method to create Category, using Realm
    
    func createCategory(title: String, emoji: String) {
        realmService.addCategory(emoji: emoji, title: title)
    }
}
