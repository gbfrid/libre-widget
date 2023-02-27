//
//  ContentView.swift
//  LibreWidget
//
//  Created by Gabe Fridkis on 2/22/23.
//

import SwiftUI



struct ContentView: View {
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    

    @State var data = [Data]()
    @State var value = 0
    @State var time = ""
    

    var body: some View {

        Text("\(time)").font(.system(size: 18, weight: .ultraLight))
        Text("\(value)").font(.system(size: 75, weight: .bold, design: .default))
        Text("mg/dL").font(.system(size: 18, weight: .ultraLight))

        .onAppear() {
            print("i exist")
            Api().loadData { (data) in
                self.data = data
                print(data[0].glucoseMeasurement.Timestamp)
                self.value = data[0].glucoseMeasurement.Value
                let timeStampArr = data[0].glucoseMeasurement.Timestamp.components(separatedBy: " ")
                self.time = String(timeStampArr[1].dropLast(3)) + " " + timeStampArr[2]
                
                let fileContent = String(self.value)
                let sharedGroupContainerDirectory = FileManager().containerURL(
                  forSecurityApplicationGroupIdentifier: "group.com.LibreWidget")
                guard let fileURL = sharedGroupContainerDirectory?.appendingPathComponent("sharedFile.json") else { return }
                try? fileContent.data(using: .utf8)!.write(to: fileURL)
            }
        }
        .onReceive(timer) { _ in
            
            Api().loadData { (data) in
                self.data = data
                self.value = data[0].glucoseMeasurement.Value
                
                
                let timeStampArr = data[0].glucoseMeasurement.Timestamp.components(separatedBy: " ")
                
                self.time = String(timeStampArr[1].dropLast(3)) + " " + timeStampArr[2]
                
                let fileContent = String(self.value)
                let sharedGroupContainerDirectory = FileManager().containerURL(
                  forSecurityApplicationGroupIdentifier: "group.com.LibreWidget")
                guard let fileURL = sharedGroupContainerDirectory?.appendingPathComponent("sharedFile.json") else { return }
                try? fileContent.data(using: .utf8)!.write(to: fileURL)
        

            }
        }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
