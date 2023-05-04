//
//  LocationManager.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/11/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
        
    // 拒絕服務變數，預設使用者同意，如拒絕則設為true
    @Published var permissionDenied = false
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
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
        
        DispatchQueue.main.async {
            self.location = location.coordinate
        }
        
//        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
//        // 更新地圖
//        self.mapView.setRegion(self.region, animated: true)
        
//        self.updateMapRegion(location: userLocation)
        
//        // 滑順動畫
//        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }

}
