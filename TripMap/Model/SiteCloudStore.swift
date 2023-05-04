//
//  SiteCloudStore.swift
//  TripMap
//
//  Created by 廖家慶 on 2023/5/4.
//

import CloudKit
import SwiftUI

class SiteCloudStore: ObservableObject {

    @Published var Sites: [CKRecord] = []

    func fetchRestaurants() async throws {
        // 使用便利型 API 取得資料
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Site", predicate: predicate)

        let results = try await publicDatabase.records(matching: query)

        for record in results.matchResults {
            self.Sites.append(try record.1.get())
        }
    }
}
