//
//  StorageManager.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import RealmSwift

class StorageManager {
    
    private let realm = try! Realm()
    
    // method for saving object
    func save<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error saving a \(object), \(error)")
        }
    }
    
    // method for load object
    func load<T: Object>(_ objectType: T.Type) -> Results<T> {
        return realm.objects(objectType)
    }
    
    // method for deletion
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting a \(object), \(error)")
        }
    }
    
}
