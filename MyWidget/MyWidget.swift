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
    var data: [modelData]
}

var dataJSONAll: [modelData] = [] // FIXME: (a)

// Provider
struct Provider: TimelineProvider{
    
    
    func placeholder(in context: Context) -> Model {
        return Model(date: Date(), data: dataJSONAll)  // FIXME: (b)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> Void) {
        completion(Model(date: Date(), data: dataJSONAll))  // FIXME: (c)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        getDataJSON { dataJSON in
            dataJSONAll = dataJSON // FIXME: (d)
            let data = Model(date: Date(), data: dataJSON)
            guard let update = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) else { return } // Update every 30 minutes
            let timeline = Timeline(entries: [data], policy: .after(update))
            completion(timeline)
        }
    }
    
    typealias Entry = Model
    
}


// Design - View
struct WidgetView: View{
    let entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View{
        //        VStack(alignment: .leading){
        //            Text("List of items").font(.title).bold()
        //            ForEach(entry.data, id: \.id) { item in
        //                Text("\(item.id) - \(item.name)").bold()
        //                Text(item.email)
        //            }
        //        }
        switch family {
        case .systemSmall:
            VStack(alignment: .center){
                Text("My list")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                Spacer()
                Text(String(entry.data.count))
                    .font(.custom("Arial-Bold", size: 80))
                    .bold()
                Spacer()
            }
        case .systemMedium:
            VStack(alignment: .center){
                Text("My list")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                Spacer()
                VStack(alignment: .leading){
                    Text(entry.data[0].name).bold()
                    Text(entry.data[0].email)
                    Text(entry.data[1].name).bold()
                    Text(entry.data[1].email)
                }.padding(.leading)
                Spacer()
            }
        default:
            VStack(alignment: .center){
                Text("My list")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                Spacer()
                VStack(alignment: .leading){
                    ForEach(entry.data, id: \.id) { item in
                        Text("\(item.id) - \(item.name)").bold()
                        Text(item.email)
                    }
                }.padding(.leading)
                Spacer()
            }
        }
    }
}

// Configuration
struct HelloWidget: Widget{
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "widget", provider: Provider()) { itemEntry in
            WidgetView(entry: itemEntry)
        }.description("A simple widget...")
            .configurationDisplayName("Widget App 🚀")
            .supportedFamilies([.systemLarge, .systemSmall, .systemMedium])
    }
    
}

// Model Data
struct modelData: Decodable {
    var id: Int
    var name: String
    var email: String
    
}

func getDataJSON(completion: @escaping ([modelData]) -> ()){
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=1") else { return }
    
    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data else { return }
        
        do{
            let json = try JSONDecoder().decode([modelData].self, from: data)
            DispatchQueue.main.async{
                completion(json)
            }
        }catch let error as NSError{
            debugPrint("Error al obtener la data",error.localizedDescription)
        }
    }.resume()
}
