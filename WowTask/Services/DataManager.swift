//
//  DataManager.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 20.10.2021.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func fetchItemList(includingCompleted: Bool) -> [Task]
    func addTask(task: String, priority: Priority, isComplete: Bool)
    func toggleIsCompleted(for todo: Task)
    func deleteItems(items: [Task])
}

class DataManager {
    static let shared: DataManagerProtocol = DataManager()
    
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
    private init() { }
    
    private func getItemMO(for todo: Task) -> TaskMO? {
        let predicate = NSPredicate(
            format: "id = %@",
            todo.id as CVarArg)
        let result = dbHelper.fetchFirst(TaskMO.self, predicate: predicate)
        switch result {
        case .success(let todoMO):
            return todoMO
        case .failure(_):
            return nil
        }
    }
}

// MARK: - DataManagerProtocol
extension DataManager: DataManagerProtocol {
    func fetchItemList(includingCompleted: Bool = false) -> [Task] {
        let predicate = includingCompleted ? nil : NSPredicate(format: "isCompleted == false")
        let result: Result<[TaskMO], Error> = dbHelper.fetch(TaskMO.self, predicate: predicate, sortDescriptors: [NSSortDescriptor(keyPath: \TaskMO.priorityNum, ascending: false)])
        switch result {
        case .success(let itemMOs):
            return itemMOs.map { $0.convertToTask() }
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func addTask(task: String, priority: Priority, isComplete: Bool) {
        let entity = TaskMO.entity()
        
        let newItem = TaskMO(entity: entity, insertInto: dbHelper.context)
        newItem.id = UUID()
        newItem.text = task
        newItem.priority = priority
        newItem.isCompleted = isComplete
        newItem.timestamp = Date()
    
        dbHelper.create(newItem)
    }
    
    func toggleIsCompleted(for item: Task) {
        guard let itemMO = getItemMO(for: item) else { return }
        itemMO.isCompleted.toggle()
        dbHelper.update(itemMO)
    }
    
    func deleteItems(items: [Task]) {
        items.forEach { item in
            let itemMO = getItemMO(for: item)
            guard let item = itemMO else { return }
            dbHelper.delete(item)
        }
    }
}
