//
//  SitesViewModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/29.
//

import Foundation
import Combine
import UIKit

class SiteViewModel: ObservableObject, Identifiable {

    @Published var address: String = ""
    @Published var content: String = ""
    @Published var coverImage: Data = Data()
    @Published var hackMDUrl: String = ""
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
            self.hackMDUrl = site.hackMDUrl
            self.id = site.id
            self.latitude = site.latitude
            self.longitude = site.longitude
            self.name = site.name
            self.star = site.star
            self.time = site.time
        }
    }
    
    func toSite() -> Site {
        let site = Site()
        site.address = self.address
        site.content = self.content
        site.coverImage = self.coverImage
        site.hackMDUrl = self.hackMDUrl
        site.id = self.id
        site.latitude = self.latitude
        site.longitude = self.longitude
        site.name = self.name
        site.star = self.star
        site.time = self.time
        
        return site
    }
}

extension SiteViewModel: Equatable {
    public static func == (a: SiteViewModel, b: SiteViewModel) -> Bool {
        return a.address == b.address && a.content == b.content && a.coverImage == b.coverImage && a.latitude == b.latitude && a.longitude == b.longitude && a.name == b.name && a.star == b.star
    }
}
