//
//  ToDoListViewModelType.swift
//  ToDoApp
//
//  Created by Мявкo on 21.10.23.
//

import Foundation

protocol ToDoListViewModelType {
    var numberOfRows: Int { get }
    var heightOfRow: CGFloat { get }
    
    func loadTasks()
    func cellViewModel(for indexPath: IndexPath) -> ToDoItemCellViewModelType?
    func didSelectRow(at indexPath: IndexPath)
}
