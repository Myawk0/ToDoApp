//
//  CategoryCellViewModelType.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

protocol CategoryCellViewModelType: AnyObject {
    var emoji: String { get }
    var title: String { get }
    var countTasks: Int { get }
    func updateCategory(emoji: String)
    func deleteCategory() 
}
