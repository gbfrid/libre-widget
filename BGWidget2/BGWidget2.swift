//
//  BGWidget2.swift
//  BGWidget2
//
//  Created by Gabe Fridkis on 2/25/23.
//

import WidgetKit
import SwiftUI
import Foundation



struct Result: Decodable {
    
    let data: [Data]
}

struct Data: Decodable, Identifiable {
    let id: String
    
    let firstName: String
    let glucoseMeasurement: GlucoseMeasurement
    
    
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case glucoseMeasurement
        case id
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: .firstName)
        glucoseMeasurement = try values.decode(GlucoseMeasurement.self, forKey: .glucoseMeasurement)
        id = try values.decode(String.self, forKey: .id)
    }
}



struct GlucoseMeasurement: Codable {
    let Timestamp: String
    let Value: Int
}


struct GlucoseMeasurementEntry: TimelineEntry {
    var date: Date
    let day: String
    let time: String
    let value: Int
}

func loadData(completion:@escaping ([Data]) -> ()) {
    guard let url = URL(string: "https://api.libreview.io/llu/connections") else {
        print("Invalid url...")
        return
    }
    
    
    var request = URLRequest(url: url)
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImUwNjY0NGZhLWIyZWUtMTFlZC05MDhlLTAyNDJhYzExMDAwYSIsImZpcnN0TmFtZSI6IkdhYmUgIiwibGFzdE5hbWUiOiJNZW5kZSIsImNvdW50cnkiOiJVUyIsInJlZ2lvbiI6InVzIiwicm9sZSI6InBhdGllbnQiLCJ1bml0cyI6MSwicHJhY3RpY2VzIjpbXSwiYyI6MSwicyI6ImxsdS5hbmRyb2lkIiwiZXhwIjoxNjkyNjU2NzE3fQ.6D3Z_S2dwFhiuARNjZrMrm7D0XKHVXq6ML4C5a9YWU4"
    
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("gzip", forHTTPHeaderField: "accept-encoding")
    request.addValue("no-cache", forHTTPHeaderField: "cache-control")
    request.addValue("Keep-Alive", forHTTPHeaderField: "connection")
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("llu.android", forHTTPHeaderField: "product")
    request.addValue("4.2.1", forHTTPHeaderField: "version")
    
    
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
        
        let res = try! JSONDecoder().decode(Result.self, from: data!)
        
        completion(res.data)
        
    }.resume()
    
}






struct Provider: TimelineProvider {
    
    
    
    typealias Entry = GlucoseMeasurementEntry
    
    func placeholder(in context: Context) -> GlucoseMeasurementEntry {
        GlucoseMeasurementEntry(date: Date(), day: "12/23", time: "12:24 AM", value: 69)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (GlucoseMeasurementEntry) -> ()) {
        let entry = GlucoseMeasurementEntry(date: Date(), day: "12/23", time: "12:24 AM", value: 69)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        
        
        Task {
            
            
            loadData { (data) in
                
                let value = data[0].glucoseMeasurement.Value
                let timeStampRaw = data[0].glucoseMeasurement.Timestamp
                let timeStampArr = timeStampRaw.components(separatedBy: " ")
                let time = String(timeStampArr[1].dropLast(3)) + " " + timeStampArr[2]
                let day = String(timeStampArr[0].dropLast(5))
                
                let entry = GlucoseMeasurementEntry(date: Date(), day: day, time: time, value: value)
                
                let nextUpdate = Calendar.current.date(
                    byAdding: DateComponents(minute: 1),
                    to: Date()
                )!
                
                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(nextUpdate)
                )
                
                completion(timeline)
                
            }
            
            
        }
        
    }
}



struct BGWidget2EntryView : View {
    var entry: GlucoseMeasurementEntry
    
    
    @Environment(\.widgetFamily)
    var family
    
    var body: some View {
        
        switch family {
        case .accessoryRectangular:
            RectangularWidgetView(entry: entry)
        case .accessoryCircular:
            CircularWidgetView(entry: entry)
            
        default:
            
            HomeScreenWidgetView(entry: entry)
        }
    }
    
    
    
    
}

struct HomeScreenWidgetView : View {
    
    var entry: GlucoseMeasurementEntry
    
    var body: some View {
        ZStack {
            Color(entry.value  < 70 ? .red : entry.value < 160 ? .green : .yellow)
            VStack {
                HStack {
                    Spacer()
                    Text("\(entry.day)").font(.system(size: 12))
                }
                
                Spacer()
                Text("\(entry.time)").font(.system(size: 12))
                
                
                Text("\(entry.value)").font(.system(size: 55, weight: .bold))
                Spacer()
                
            }
            .padding(8)
            
        }
        
    }
}

struct CircularWidgetView: View {
    
    var entry: GlucoseMeasurementEntry
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AccessoryWidgetBackground()
                VStack {
                    Text("\(entry.value)")
                }
            }
        }
    }
}

struct RectangularWidgetView: View {
    
    var entry: GlucoseMeasurementEntry
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("\(entry.time)").font(.footnote)
                Text("\(entry.value)").font(.system(size: 25, weight: .bold))
            }
        }
    }
}

struct BGWidget2: Widget {
    let kind: String = "BGWidget2"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BGWidget2EntryView(entry: entry)
        }
        .configurationDisplayName("LibreWidget")
        .description("Check your blood sugar")
        .supportedFamilies([
            .systemSmall,
            .accessoryCircular,
            .accessoryRectangular,
        ])
    }
}

