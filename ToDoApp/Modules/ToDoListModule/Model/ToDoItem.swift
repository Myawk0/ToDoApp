//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @Persisted var task: String = ""
    @Persisted var done: Bool = false
    @Persisted var orderIndex: Int?
    
    @Persisted var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
}

