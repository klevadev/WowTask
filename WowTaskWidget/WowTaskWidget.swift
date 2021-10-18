//
//  WowTaskWidget.swift
//  WowTaskWidget
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WowTaskWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var fontStyle: Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote, design: .rounded)
        } else {
            return .system(.headline, design: .rounded)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                
                Image("logo")
                    .resizable()
                    .frame(
                        width: widgetFamily != .systemSmall ? 56 : 36,
                        height: widgetFamily != .systemSmall ? 56 : 36)
                    .offset(
                        x: (geometry.size.width / 2) - 20,
                            y: (geometry.size.height / -2) + 20
                    )
                    .padding(.top, widgetFamily != .systemSmall ? 32 : 12)
                    .padding(.trailing, widgetFamily != .systemSmall ? 32 : 12)
                
                HStack {
                    Text("Just Do It")
                        .foregroundColor(.white)
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Color(red: 0, green: 0, blue: 0, opacity: 0.5)
                                .blendMode(.overlay)
                        )
                    .clipShape(Capsule())
                    
                    if widgetFamily != .systemSmall {
                        Spacer()
                    }
                } //: HStack
                .padding()
                .offset(
                    y: (geometry.size.height / 2) - 24
                )
            } //: ZSTACK
        } //: GeometryReader
    }
}

@main
struct WowTaskWidget: Widget {
    let kind: String = "WowTaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WowTaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WowTask Лаунчер")
        .description("Это пример простого виджета для трекера задач.")
    }
}

struct WowTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        WowTaskWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        WowTaskWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        WowTaskWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
