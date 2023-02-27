//
//  BGWidget.swift
//  BGWidget
//
//  Created by Gabe Fridkis on 2/24/23.
//

import WidgetKit
import SwiftUI
import Intents

struct GlucoseMeasurement: Codable {
    let Timestamp: String
    let Value: Int
}

struct Provider: IntentTimelineProvider {
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), value: "88")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        print("HI")
        let entry = SimpleEntry(date: Date(), configuration: configuration, value: "23")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        
        
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!

        
        for offset in 0 ..< 60 * 24 {
            

            WidgetCenter.shared.reloadAllTimelines()
            
            let sharedGroupContainerDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.com.LibreWidget")
            
            guard let fileURL = sharedGroupContainerDirectory?.appendingPathComponent("sharedFile.json") else { return }

            guard let fileContent = try? Data(contentsOf: fileURL) else { return }
            let testBG = String(data: fileContent, encoding: .utf8)
            
            
            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: midnight)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, value: testBG!)
            entries.append(entry)
               }
        
       
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let value: String
}

struct BGWidgetEntryView : View {
    
    var entry: Provider.Entry

    var body: some View {
//        Text("\(entry.date)")
        Text("\(entry.value)").font(.system(size: 35, weight: .bold, design: .default))
    }
}

struct BGWidget: Widget {
    let kind: String = "BGWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BGWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

