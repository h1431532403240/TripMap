//
//  Persistence.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let site = Site(context: viewContext)
        site.coverImage = (UIImage(named: "Cat")?.jpegData(compressionQuality: 1.0))!
        site.time = Date()
        site.star = 3
        site.name = "貓咪餐廳"
        site.id = UUID().uuidString
        site.address = "台南市永康區南台街1號"
        site.hackMDUrl = "https://hackmd.io/@MvQ4L8zNSNqT07komVcx3A/HyKQ6Gl4h"
        site.latitude = 23.0222115138
        site.longitude = 120.224012996
        site.content = """
        # hehe

        Nice o

        ![圖片標題](https://i.imgur.com/eismTPI.jpg)
        ![圖片標題](https://i.imgur.com/8RUYXKg.jpg)
        """
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var testData: [Site]? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Site")
        return try? PersistenceController.preview.container.viewContext.fetch(fetchRequest) as? [Site]
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TripMap")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
