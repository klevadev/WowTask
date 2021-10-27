//
//  EmptyListView.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 26.10.2021.
//

import SwiftUI

struct EmptyListView: View {
  // MARK: - PROPERTIES
  
  @State private var isAnimated: Bool = false
  
  let images: [String] = [
    "illustration-no1",
    "illustration-no2",
    "illustration-no3"
  ]
  
  let tips: [String] = [
    "Используйте свое время с умом.",
    "Тише едешь - дальше будешь.",
    "Сделайте это коротко и мило.",
    "Выполняйте сложные задачи в первую очередь.",
    "Наградите себя после работы.",
    "Планируйте задачи заранее."
  ]
  
  // MARK: - BODY
  
  var body: some View {
    ZStack {
      VStack(alignment: .center, spacing: 20) {
        Image("\(images.randomElement() ?? self.images[0])")
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
          .layoutPriority(1)
          .foregroundColor(.white)
        
        Text("\(tips.randomElement() ?? self.tips[0])")
          .layoutPriority(0.5)
          .font(.system(.headline, design: .rounded))
          .foregroundColor(.white)
      } //: VSTACK
        .padding(.horizontal)
        .opacity(isAnimated ? 1 : 0)
        .offset(y: isAnimated ? 0 : -50)
        .animation(.easeOut(duration: 1.5))
        .onAppear(perform: {
           self.isAnimated.toggle()
        })
    } //: ZSTACK
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .edgesIgnoringSafeArea(.all)
  }
}

// MARK: - PREVIEW

struct EmptyListView_Previews: PreviewProvider {
  static var previews: some View {
      EmptyListView().background(
        backgroundGradient.ignoresSafeArea(.all)
    )
  }
}
