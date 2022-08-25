//
//  Place.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: CLPlacemark
    
}

extension CLPlacemark {
    // 獲取詳細地址
    func getFullAddress() -> String? {
        // 縣市名稱
//        guard let _subAdministrativeArea = subAdministrativeArea else { return "" }
        // 市區名稱
        guard let _locality = locality else { return ""}
        // 街道名稱
        guard let _thoroughfare = thoroughfare else { return ""}
        // 門牌號碼
        guard let _subThoroughfare = subThoroughfare else { return ""}
        
        let fullAddress =  _locality + _thoroughfare + _subThoroughfare + "號"
        
        return fullAddress
    }
}
