//
//  ListRowItemView.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import SwiftUI

protocol ListRowItemViewProtocol {
    func updateIsCompleted(with task: Task)
}

struct ListRowItemView: View {
    // MARK: - PROPERTY
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: Task
    var delegate: ListRowItemViewProtocol
    
    
    // MARK: - FUNCTION
    private func color(for priority: Priority) -> Color {
        switch priority {
        case .high: return .red
        case .normal: return .orange
        case .low: return .green
        }
    }
    
    // MARK: - BODY
    var body: some View {
        Toggle(isOn: $task.isCompleted) {
            HStack {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(self.color(for: self.task.priority))
                
                Text(task.text)
                    .strikethrough(task.isCompleted, color: isDarkMode ? .white : .black)
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(task.isCompleted ? .pink : Color.primary)
                    .padding(.vertical, 12)
                    .animation(.default)
            }
        } //: TOGGLE
        .onChange(of: task.isCompleted) { _ in
            delegate.updateIsCompleted(with: task)
        }
        .toggleStyle(CheckboxStyle())
    }
}
