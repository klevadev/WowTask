//
//  TaskMO.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 19.10.2021.
//

import Foundation
import CoreData

enum Priority: Int {
    case low = 0
    case normal = 1
    case high = 2
}

@objc(TaskMO)
final class TaskMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var priorityNum: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var timestamp: Date
}

extension TaskMO: Identifiable {
    
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityNum)) ?? .normal
        }
        
        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
}

extension TaskMO {
    func convertToTask() -> Task {
        Task(id: id,
             text: text,
             priorityNum: priorityNum,
             isCompleted: isCompleted,
             timestamp: timestamp)
    }
}
