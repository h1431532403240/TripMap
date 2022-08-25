//
//  Projects+CoreDataProperties.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/25.
//
//

import Foundation
import CoreData


extension Projects {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Projects> {
        return NSFetchRequest<Projects>(entityName: "Projects")
    }

    @NSManaged public var emoji: String?
    @NSManaged public var name: String?
    @NSManaged public var toSite: NSSet?

}

// MARK: Generated accessors for toSite
extension Projects {

    @objc(addToSiteObject:)
    @NSManaged public func addToToSite(_ value: Sites)

    @objc(removeToSiteObject:)
    @NSManaged public func removeFromToSite(_ value: Sites)

    @objc(addToSite:)
    @NSManaged public func addToToSite(_ values: NSSet)

    @objc(removeToSite:)
    @NSManaged public func removeFromToSite(_ values: NSSet)

}

extension Projects : Identifiable {

}
