//
//  MapBoxMapView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//


import SwiftUI
import UIKit
@_spi(Experimental) import MapboxMaps

struct MapBoxMapView: UIViewControllerRepresentable {
    
    @EnvironmentObject var mapData: MapboxMapViewModel
        
    func makeUIViewController(context: Context) -> MapboxMapViewModel {
        let view = mapData
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: MapboxMapViewModel, context: Context) {
        
    }
}

