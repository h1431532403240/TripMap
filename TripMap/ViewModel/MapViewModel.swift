//
//  MapViewModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import SwiftUI
import MapKit
import CoreLocation
import Contacts

// 所有Map資料
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Environment(\.dismiss) var dismiss
            
    // 地圖位置
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.02353, longitude: 120.22478), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
    @Published var userLocation = CLLocationCoordinate2D()
    
    // 預設地點
    @Published var region: MKCoordinateRegion!
        
    // 拒絕服務變數，預設使用者同意，如拒絕則設為true
    @Published var permissionDenied = false
    
    // 地圖類型
    @Published var mapType: MKMapType = .standard
    
    // 搜尋文字
    @Published var searchText: String = ""
    
    // 搜索地點儲存
    @Published var places: [Place] = []
    
    @Published var centerLocation: CLLocationCoordinate2D?

    @Published var address: String = ""
    
    func updateMapRegion(location: CLLocationCoordinate2D) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location,
                span: mapSpan)
        }
    }

    func getAddress(location: CLLocation, completion: @escaping (_ address: String) -> Void) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "zh_TW")) { placemark, error in
            guard let placemark = placemark?.first, error == nil else { return }
            guard let address = placemark.getFullAddress() else { return }
//            var address: String = ""
//            address += placemark.country ?? ""
//            address += placemark.administrativeArea ?? ""
//            address += placemark.subAdministrativeArea ?? ""
//            address += placemark.locality ?? ""
//            address += placemark.subLocality ?? ""
//            address += placemark.thoroughfare ?? ""
//            address += placemark.subThoroughfare ?? ""
//            address += "號"

            print("經度：\(String(describing: location.coordinate.longitude) ), 緯度：\(String(describing: location.coordinate.latitude))")
            completion(address)
        }
    }
    
    // 前往個人定位
    func currentLocation() {
        self.updateMapRegion(location: self.userLocation)
    }
    
    // 搜尋地點
    func searchPlace() {
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        // 獲取
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else { return }
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(place: item.placemark)
            })
        }
    }
    
    // 選取搜尋結果
    func selectPlace(place: Place) {
        searchText = ""
        
        guard let coordinate = place.place.location?.coordinate else { return }
        
        updateMapRegion(location: coordinate)
    }
    
    // 確認定位服務是否開啟
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        // 尚未做出是否給予定位服務決定
        case .notDetermined:
            // 發出是否同意許可
            manager.requestWhenInUseAuthorization()
        // 使用者拒絕給予權限
        case .denied:
            // 調整permissionDenied變數
            permissionDenied.toggle()
        // 使用者給予定位權限
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 錯誤
        print(error.localizedDescription)
    }
    
    // 獲取使用者位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        self.userLocation = location.coordinate
        
        self.updateMapRegion(location: userLocation)
    }
    
}
