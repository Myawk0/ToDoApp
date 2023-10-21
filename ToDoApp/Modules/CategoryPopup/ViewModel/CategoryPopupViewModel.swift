//
//  CategoryPopupViewModel.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

class CategoryPopupViewModel: CategoryPopupViewModelType {
    
    private let realmService = RealmCategories.shared
    
    var emoji: Box<String?> = Box(nil)
    
    func createCategory(title: String, emoji: String) {
        realmService.addCategory(emoji: emoji, title: title)
    }
}
