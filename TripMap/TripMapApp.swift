//
//  TripMapApp.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import SwiftUI

@main
struct TripMapApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ListView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
