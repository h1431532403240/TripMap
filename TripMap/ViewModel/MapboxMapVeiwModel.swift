//
//  MapboxMapVeiwModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import SwiftUI
import MapKit
@_spi(Experimental) import MapboxMaps

class MapboxMapViewModel: UIViewController, ObservableObject, LocationPermissionsDelegate {
        
    internal var mapView: MapView!
    
    @Published var isLocationAuthorizationStatus = false
        
    @Published var searchText = ""
    
    @Published var places: [Place] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let myResourceOptions = ResourceOptions(accessToken: "sk.eyJ1IjoiaDE0MzE1MzI0MDMyNDAiLCJhIjoiY2t6b2Q0Nm5lMzV1cTJvbzBndmIyY3F2aiJ9.x17f6TjsW-6aiV9eseIU5A")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.ornaments.options.scaleBar.visibility = .hidden
        self.view.addSubview(mapView)
        
        mapView.location.delegate = self
        mapView.location.options.activityType = .other
        mapView.location.options.puckType = .puck2D()
        mapView.location.locationProvider.startUpdatingLocation()
        
        initUserLocation()
        
        locationManagerDidChangeAuthorization()

    }
    
    func initUserLocation() {

        // 設置使用者位置的鏡頭設定
        let followPuckViewportState = mapView.viewport.makeFollowPuckViewportState(
            options: FollowPuckViewportStateOptions(
                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                zoom: 15,
                pitch: 0))

        // 不設置過場動畫
        let immediateTransition = mapView.viewport.makeImmediateViewportTransition()

        // 鏡頭轉到使用者的Puck
        mapView.viewport.transition(to: followPuckViewportState, transition: immediateTransition) { success in
            // 傳送成功輸出成功
            print("completed")
        }
    }
    
    func currentLocation() {
        if (self.mapView?.location.latestLocation?.coordinate) != nil {
            mapView.mapboxMap.setCamera(to: CameraOptions(center: mapView.location.latestLocation!.coordinate, zoom: 15))
        }
        else {
            print("can't setting location")
        }
    }
    
    func searchPlace() {
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        // 獲取所有地點
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else { return }
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(place: item.placemark)
            })
        }
    }
    
    func selectPlace(place: Place) {
        searchText = ""
        
        guard let coordinate = place.place.location?.coordinate else { return }
        
        var pointAnnotation = PointAnnotation(coordinate: coordinate)
        pointAnnotation.image = .init(image: UIImage(named: "red_pin")!, name: place.place.name ?? "沒有名稱")
        
        mapView.mapboxMap.setCamera(to: CameraOptions(center: coordinate, zoom: 15))
        
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.annotations = [pointAnnotation]
    }
    
    func locationManagerDidChangeAuthorization() {
        switch mapView.location.locationProvider.authorizationStatus {
            
        case .notDetermined:
            mapView.location.locationProvider.requestAlwaysAuthorization()
        case .denied:
            isLocationAuthorizationStatus.toggle()
        case .authorizedAlways, .authorizedWhenInUse, .restricted:
            ()
        @unknown default:
            ()
        }
    }
}
