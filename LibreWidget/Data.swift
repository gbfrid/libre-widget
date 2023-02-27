//
//  Data.swift
//  LibreWidget
//
//  Created by Gabe Fridkis on 2/23/23.
//

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





class Api : ObservableObject{
    //    @Published var glucoseReadings = [Result]()
    
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
            
            //            var test = GlucoseMeasurement(Timestamp: "01/01/2001 10:10:00 AM", Value: 69)
            //            var testData = try! JSONEncoder().encode(test)
            
            let fileContent = "73"
            let sharedGroupContainerDirectory = FileManager().containerURL(
                forSecurityApplicationGroupIdentifier: "group.com.LibreWidget")
            guard let fileURL = sharedGroupContainerDirectory?.appendingPathComponent("sharedFile.json") else { return }
            try? fileContent.data(using: .utf8)!.write(to: fileURL)
            
            //            UserDefaults(suiteName: "group.com.LibreWidget")!.set(testData, forKey: "test")
            print(res.data)
            
            DispatchQueue.main.async {
                completion(res.data)
            }
        }.resume()
        
    }
}
