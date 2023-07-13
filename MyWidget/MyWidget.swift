//
//  MyWidget.swift
//  MyWidget
//
//  Created by Pierre Juarez U. on 12/07/23.
//

import WidgetKit
import SwiftUI

// Model
struct Model: TimelineEntry{
    var date: Date
    var message: String
}

// Provider
struct Provider: TimelineProvider{
    func placeholder(in context: Context) -> Model {
        return Model(date: Date(), message: "")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> Void) {
        completion(Model(date: Date(), message: ""))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        let entry = Model(date: Date(), message: "Hello world! 🤩")
        completion(Timeline(entries: [entry], policy: .never))
    }
    
    typealias Entry = Model
    
}


// Design - View
struct WidgetView: View{
    let entry: Provider.Entry
    var body: some View{
        Text(entry.message)
    }
}

// Configuration
struct HelloWidget: Widget{
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "widget", provider: Provider()) { itemEntry in
            WidgetView(entry: itemEntry)
        }.description("A simple widget...")
            .configurationDisplayName("Widget App 🚀")
            .supportedFamilies([.systemSmall, .systemLarge, .systemMedium])
    }

}
