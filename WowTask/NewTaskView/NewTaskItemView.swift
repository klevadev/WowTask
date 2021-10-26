//
//  NewTaskItemView.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - PROPERTY
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @State private var task: String = ""
    @State var priority: Priority
    
    @Binding var isShowing: Bool
    
    @ObservedObject var viewModel: NewTaskViewModel
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // MARK: - FUNCTION
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Новое задание", text: $task)
                        .foregroundColor(.pink)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .padding()
                        .background(
                            isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.systemGray6)
                        )
                        .cornerRadius(10)
                    
                    Text("Приоритет")
                        .font(.system(.headline, design: .rounded))
                        .padding(.vertical, 10)
                    
                    HStack {
                        Text("Высокий")
                            .font(.system(.headline, design: .rounded))
                            .padding(10)
                            .background(priority == .high ? Color.red : Color(.systemGray4))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.priority = .high
                            }
                        
                        Text("Обычный")
                            .font(.system(.headline, design: .rounded))
                            .padding(10)
                            .background(priority == .normal ? Color.orange : Color(.systemGray4))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.priority = .normal
                            }
                        
                        Text("Низкий")
                            .font(.system(.headline, design: .rounded))
                            .padding(10)
                            .background(priority == .low ? Color.green : Color(.systemGray4))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.priority = .low
                            }
                    }
                    .padding(.bottom, 30)
                    
                    Button {
                        viewModel.addNewTask(task: self.task, priority: self.priority)
                        TaskAudioPlayer.shared.playSound(sound: Sound.ding.rawValue)
                        feedBack.notificationOccurred(.success)
                        hideKeyboard()
                        isShowing = false
                    } label: {
                        Spacer()
                        Text("Сохранить")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer()
                    }
                    .disabled(isButtonDisabled)
                    .onTapGesture {
                        if isButtonDisabled {
                            TaskAudioPlayer.shared.playSound(sound: Sound.tap.rawValue)
                        }
                    }
                    .padding()
                    .foregroundColor(
                        .white
                    )
                    .background(isButtonDisabled ? Color.blue : Color.pink)
                    .cornerRadius(10)
                    
                } //: VStack
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(
                    isDarkMode ? Color(UIColor.secondarySystemBackground) : .white
                )
                .cornerRadius(16)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
                .frame(maxWidth: 640)
            } //: VStack
            .padding()
        }
    }
    
    struct NewTaskItemView_Previews: PreviewProvider {
        static var previews: some View {
            NewTaskItemView(priority: .normal, isShowing: .constant(true), viewModel: NewTaskViewModel())
                .background(Color.gray.edgesIgnoringSafeArea(.all))
//                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
