//
//  NewTaskViewModel.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 20.10.2021.
//

import Foundation
import Combine

protocol NewTaskViewModelProtocol {
    func addNewTask(task: String, priority: Priority, isComplete: Bool)
}

final class NewTaskViewModel: ObservableObject {
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }
}

// MARK: - NewTodoViewModelProtocol
extension NewTaskViewModel: NewTaskViewModelProtocol {
    func addNewTask(task: String, priority: Priority, isComplete: Bool = false) {
        dataManager.addTask(task: task, priority: priority, isComplete: isComplete)
    }
}
