//
//  Projects+CoreDataProperties.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/28.
//
//

import Foundation
import CoreData


extension Projects {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Projects> {
        return NSFetchRequest<Projects>(entityName: "Projects")
    }

    @NSManaged public var emoji: String?
    @NSManaged public var play: String?
    @NSManaged public var sites: NSSet?
    
    public var unwrappedEmoji: String {
        emoji ?? "❓"
    }
    
    public var unwrappedPlay: String {
        play ?? "Unknown Play"
    }
    
    public var sitesArray: [Sites] {
        let set = sites as? Set<Sites> ?? []
        
        return set.sorted {
            $0.unwrappedDate < $1.unwrappedDate
        }
    }

}

// MARK: Generated accessors for sites
extension Projects {

    @objc(addSitesObject:)
    @NSManaged public func addToSites(_ value: Sites)

    @objc(removeSitesObject:)
    @NSManaged public func removeFromSites(_ value: Sites)

    @objc(addSites:)
    @NSManaged public func addToSites(_ values: NSSet)

    @objc(removeSites:)
    @NSManaged public func removeFromSites(_ values: NSSet)

}

extension Projects : Identifiable {

}
