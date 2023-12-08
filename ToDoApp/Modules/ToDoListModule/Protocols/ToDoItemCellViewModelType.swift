//
//  ToDoItemCellViewModelType.swift
//  ToDoApp
//
//  Created by Мявкo on 21.10.23.
//

import Foundation

protocol ToDoItemCellViewModelType {
    var indexPath: IndexPath { get set }
    var isNewItemRow: Bool { get set }
    var text: String { get }
    var isSelected: Bool { get }
    
    func updateDoneState()
    func taskIsWrittenInTextField(with text: String) 
    func taskToDelete()
    func textFieldReturnButtonTapped(with task: String) -> Int
}
