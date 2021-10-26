//
//  Task.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 20.10.2021.
//

import Foundation
import SwiftUI

struct Task: Identifiable {
    var id = UUID()
    var text: String
    var priorityNum: Int32
    var isCompleted = false
    var timestamp: Date
}

extension Task {
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityNum)) ?? .normal
        }
        
        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
}
