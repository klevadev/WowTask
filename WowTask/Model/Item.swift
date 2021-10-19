//
//  TaskItem.swift
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

@objc(Item)
public class Item: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var task: String
    @NSManaged public var priorityNum: Int32
    @NSManaged public var isComplete: Bool
    @NSManaged public var timestamp: Date
}

extension Item: Identifiable {
    
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityNum)) ?? .normal
        }
        
        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
}
