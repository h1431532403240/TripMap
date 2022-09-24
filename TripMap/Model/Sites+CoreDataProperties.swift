//
//  Sites+CoreDataProperties.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/28.
//
//

import Foundation
import CoreData
import SwiftUI


extension Sites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sites> {
        return NSFetchRequest<Sites>(entityName: "Sites")
    }

    @NSManaged public var address: String?
    @NSManaged public var content: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var star: Int64
    @NSManaged public var time: Date?
    @NSManaged public var projects: Projects?
    
    public var unwrappedAddres: String {
        address ?? "Unknown Address"
    }
    
    public var unwrappedContent: String {
        content ?? "Unknown Content"
    }
    
    public var unwrappedCoverImage: Data {
        coverImage ?? Data()
    }
    
    public var unwrappedId: String {
        id ?? UUID().uuidString
    }
    
    public var unwrappedLatitude: Double {
        return 0.0
    }
    
    public var unwrappedLongitude: Double {
        return 0.0
    }
    
    public var unwrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var unwrappedStar: Int64 {
        return 0
    }
    
    public var unwrappedDate: Date {
        time ?? Date()
    }

}

extension Sites : Identifiable {

}
