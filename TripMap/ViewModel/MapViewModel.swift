//
//  MapViewModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import SwiftUI
import MapKit
import CoreLocation

// 所有Map資料
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
    @Published var mapView = MKMapView()
    
    // 預設地點
    @Published var region: MKCoordinateRegion!
        
    // 拒絕服務變數，預設使用者同意，如拒絕則設為true
    @Published var permissionDenied = false
    
    // 地圖類型
    @Published var mapType: MKMapType = .standard
    
    // 搜尋文字
    @Published var searchText = ""
    
    // 搜索地點儲存
    @Published var places: [Place] = []
    
    @Published var centerLocation: CLLocationCoordinate2D?
        
    // 變更地圖類型
    func updateMapType() {
        
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
//    // 獲取地圖中心經緯度
//    func getCenterLocation() -> CLLocationCoordinate2D {
//        centerLocation = mapView.centerCoordinate
//        return centerLocation!
//    }
    
    // 獲取地圖中心經緯度
    func getCenterLocation() {
        centerLocation = mapView.centerCoordinate
    }

    func getAddress(location: CLLocation, completion: @escaping (_ address: String) -> Void) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "zh_TW")) { placemark, error in
            guard let placemark = placemark?.first, error == nil else { return }
            
            var address: String = ""
            address += placemark.country ?? ""
            address += placemark.administrativeArea ?? ""
            address += placemark.subAdministrativeArea ?? ""
            address += placemark.locality ?? ""
            address += placemark.subLocality ?? ""
            address += placemark.thoroughfare ?? ""
            address += placemark.subThoroughfare ?? ""
            address += "號"
                
            print("經度：\(String(describing: location.coordinate.longitude) ), 緯度：\(String(describing: location.coordinate.latitude))")
            completion(address)
        }
    }
    
    // 前往個人定位
    func currentLocation() {
                
        guard let userLocation = mapView.userLocation.location?.coordinate else { return }
        
        region.center = userLocation
                
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
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
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "沒有名稱"
        
        // 刪除其他搜尋資料
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(pointAnnotation)
        
        // 地圖移動至搜尋地點
        let corrdinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(corrdinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
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
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        // 更新地圖
        self.mapView.setRegion(self.region, animated: true)
        
        // 滑順動畫
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
}
