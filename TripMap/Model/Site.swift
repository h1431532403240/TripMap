//
//  ListModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/25.
//
import SwiftUI
import MapKit
import CoreData

public class Site: NSManagedObject {

    @NSManaged public var address: String
    @NSManaged public var content: String
    @NSManaged public var coverImage: Data
    @NSManaged public var id: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
    @NSManaged public var star: Int64
    @NSManaged public var time: Date
    @NSManaged public var project: Project
    
}

//// 以新增時間排序列表順序
//extension Site: Comparable {
//    static func == (a: Site, b: Site) -> Bool {
//        return a.time == b.time
//    }
//
//    static func < (a: Site, b: Site) -> Bool {
//        return a.time < b.time
//    }
//}
