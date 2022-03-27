//
//  ListModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/25.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct ListModel: Identifiable {
    
    var id = UUID().uuidString
    var time = Date()
    var position: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 24.929339, longitude: 121.286686)
    var image: [String?]
    var name: String?
    var star: Int = 0
    var content: String = ""
    
}

extension ListModel: Comparable {
    static func < (a: ListModel, b: ListModel) -> Bool {
        return a.time < b.time
    }
}
