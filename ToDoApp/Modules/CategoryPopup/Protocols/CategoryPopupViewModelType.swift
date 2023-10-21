//
//  CategoryPopupViewModelType.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

protocol CategoryPopupViewModelType {
    var emoji: Box<String?> { get }
    func createCategory(title: String, emoji: String)
}
