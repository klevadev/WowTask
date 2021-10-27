//
//  TaskListViewModel.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 19.10.2021.
//

import Foundation
import Combine

protocol TaskListViewModelProtocol {
    var tasks: [Task] { get }
    var showCompleted: Bool { get set }
    func fetchTasks()
    func deleteTasks(offsets: IndexSet)
    func toggleIsCompleted(for item: Task)
}

final class TaskListViewModel: ObservableObject {
    @Published var tasks = [Task]()
    @Published var showCompleted = false {
        didSet {
            fetchTasks()
        }
    }
    
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
        fetchTasks()
    }
}

// MARK: - TaskListViewModelProtocol
extension TaskListViewModel: TaskListViewModelProtocol {

    func fetchTasks() {
        tasks = dataManager.fetchItemList(includingCompleted: showCompleted)
    }
    
    func toggleIsCompleted(for item: Task) {
        dataManager.toggleIsCompleted(for: item)
        fetchTasks()
    }
    
    func deleteTasks(offsets: IndexSet) {
        
        let itemsForDelete = offsets.map { tasks[$0] }
        
        // Delete objects from CoreData
        dataManager.deleteItems(items: itemsForDelete)
        
        // Delete objects from ViewModel
        offsets.forEach { (i) in
            tasks.remove(at: i)
        }
    }
}
