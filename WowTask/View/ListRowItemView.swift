//
//  ListRowItemView.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import SwiftUI

struct ListRowItemView: View {
    // MARK: - PROPERTY
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item
    
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
        Toggle(isOn: $item.isComplete) {
            HStack {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(self.color(for: self.item.priority))
                
//                Spacer()
                
                Text(item.task)
                    .strikethrough(item.isComplete, color: .black)
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(item.isComplete ? .pink : Color.primary)
                    .padding(.vertical, 12)
                .animation(.default)
            }
        } //: TOGGLE
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange) { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
}
