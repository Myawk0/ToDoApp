//
//  Category.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import RealmSwift

class Category: Object {
    @Persisted var emoji: String = ""
    @Persisted var title: String = ""
    @Persisted var tasks = List<ToDoItem>()
    
    var countTasks: Int {
       return tasks.count
    }
}
