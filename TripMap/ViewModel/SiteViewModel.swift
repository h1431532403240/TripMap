//
//  SitesViewModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/29.
//

import Foundation
import Combine
import UIKit

class SiteViewModel: ObservableObject {

    @Published var address: String = ""
    @Published var content: String = ""
    @Published var coverImage: Data = Data()
    @Published var id: String = UUID().uuidString
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var name: String = ""
    @Published var star: Int64 = 0
    @Published var time: Date = Date()
    
    init(site: Site? = nil) {

        if let site = site {
            self.address = site.address
            self.content = site.content
            self.coverImage = site.coverImage
            self.id = site.id
            self.latitude = site.latitude
            self.longitude = site.longitude
            self.name = site.name
            self.star = site.star
            self.time = site.time
        }
    }
}
