//
//  Sites+CoreDataProperties.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/25.
//
//

import Foundation
import CoreData


extension Sites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sites> {
        return NSFetchRequest<Sites>(entityName: "Sites")
    }

    @NSManaged public var address: String?
    @NSManaged public var content: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var star: Int64
    @NSManaged public var time: Date?
    @NSManaged public var toProject: Projects?

}

extension Sites : Identifiable {

}
