//
//  ContentView.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import SwiftUI

struct TaskListView: View {
    
    // MARK: - PROPERTY
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var showNewTaskItem: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewModel = TaskListViewModel()
    
    // MARK: - FUNCTION
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - MAIN VIEW
                VStack {
                    // MARK: - HEADER
                    
                    HStack(spacing: 10) {
                        // TITLE
                        Text("WowTask")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        // TOGGLE COMPLETED TASKS BUTTON
                        
                        Button {
                            self.viewModel.showCompleted.toggle()
                            TaskAudioPlayer.shared.playSound(sound: Sound.tap.rawValue)
                            feedBack.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }
                        
                        // APPEARANCE BUTTON
                        Button {
                            // TOGGLE APPEARANCE
                            isDarkMode.toggle()
                            TaskAudioPlayer.shared.playSound(sound: Sound.tap.rawValue)
                            feedBack.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }
                    } //: HStack
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    
                    Button {
                        showNewTaskItem = true
                        TaskAudioPlayer.shared.playSound(sound: Sound.ding.rawValue)
                        feedBack.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("Новая задача")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.pink, .blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 8, x: 0, y: 4.0)
                
                    if viewModel.tasks.count == 0 {
                        Spacer(minLength: 80)
                        EmptyListView()
                    }
                                        
                    // MARK: - TASKS
                    List {
                        ForEach(viewModel.tasks) { task in
                            ListRowItemView(task: task, delegate: self)
                        }
                        .onDelete(perform:
                                    self.viewModel.deleteTasks
                        )
                    } //: LIST
                    .listStyle(.insetGrouped)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VStack
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
                // MARK: - NEW TASK ITEM
                                
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? Color.black : Color.gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }.onDisappear {
                            viewModel.fetchTasks()
                        }
                    
                    NewTaskItemView(priority: .normal, isShowing: $showNewTaskItem, viewModel: NewTaskViewModel())
                }
            } //: ZSTACK
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = UIColor.clear
            })
            .navigationBarTitle("Ежедневные задачи", displayMode: .large)
            .navigationBarHidden(true)
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
        } //: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - ListRowItemViewProtocol
extension TaskListView: ListRowItemViewProtocol {
    func updateIsCompleted(with task: Task) {
        let currentTask = viewModel.tasks.filter {$0.id == task.id}
        guard let item = currentTask.first else { return }
        viewModel.toggleIsCompleted(for: item)
    }
}


// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
