//
//  WowTaskApp.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import SwiftUI

@main
struct WowTaskApp: App {    
    let context = CoreDataHelper.shared.persistentContainer.viewContext
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, context)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
