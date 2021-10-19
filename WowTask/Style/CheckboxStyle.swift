//
//  CheckboxStyle.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    feedBack.notificationOccurred(.success)
                    
                    if configuration.isOn {
                        TaskAudioPlayer.shared.playSound(sound: Sound.rise.rawValue)
                        
                    } else {
                        TaskAudioPlayer.shared.playSound(sound: Sound.tap.rawValue)
                    }
                }
        } //: HStack
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle(isOn: .constant(false)) {
            Text("Placeholder label")
        }
        .toggleStyle(CheckboxStyle())
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
