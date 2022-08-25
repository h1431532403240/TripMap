//
//  ListModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/25.
//
import SwiftUI
import MapKit
import CoreData

struct Site: Identifiable {
    
    var id = UUID().uuidString
    var time = Date()
    var position: CLLocationCoordinate2D?
//    var position: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 24.929339, longitude: 121.286686)
    var latitude: Double?
    var longitude: Double?
    var address: String = ""
    var image: [String?]
    var coverImage: UIImage?
    var name: String = ""
    var star: Int = 0
    var content: String = ""
    
}

// 以新增時間排序列表順序
extension Site: Comparable {
    static func == (a: Site, b: Site) -> Bool {
        return a.time == b.time
    }
    
    static func < (a: Site, b: Site) -> Bool {
        return a.time < b.time
    }
}
