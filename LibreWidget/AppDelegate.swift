//
//  AppDelegate.swift
//  LibreWidget
//
//  Created by Gabe Fridkis on 2/24/23.
//

import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var data = [Data]()
    var value = 0
    var time = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // UIApplication.backgroundFetchIntervalMinimum = 0s
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        // Period: 3600s = 1 hour
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
        return true
      }
    
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // fetch data from internet now
//
//
//        Api().loadData { (data) in
//            self.data = data
//            print("AYOOO")
//            self.value = data[0].glucoseMeasurement.Value
//            let timeStampArr = data[0].glucoseMeasurement.Timestamp.components(separatedBy: " ")
//            self.time = String(timeStampArr[1].dropLast(3)) + " " + timeStampArr[2]
//
//            let fileContent = String(self.value)
//            let sharedGroupContainerDirectory = FileManager().containerURL(
//              forSecurityApplicationGroupIdentifier: "group.com.LibreWidget")
//            guard let fileURL = sharedGroupContainerDirectory?.appendingPathComponent("sharedFile.json") else { return }
//            try? fileContent.data(using: .utf8)!.write(to: fileURL)
//        }
//
//
////        if data.isNew {
////            // data download succeeded and is new
////            completionHandler(.newData)
////        } else {
////            // data downloaded succeeded and is not new
////            completionHandler(.noData)
////        }
//    }
}
