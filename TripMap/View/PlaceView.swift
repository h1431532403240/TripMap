//
//  PlaceView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/27.
//

import SwiftUI
import MapKit
import UIKit

struct PlaceView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var placeContent: Sites
//    @ObservedObject var sitesViewModel: SitesViewModel
    
    @State var position = CLLocationCoordinate2D(latitude: 0.0,
                                                longitude: 0.0)
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0,
                                       longitude: 0.0),
        latitudinalMeters: 200,
        longitudinalMeters: 200
    )
    
    struct IdentifiablePlace: Identifiable {
        let id = UUID()
        let location: CLLocationCoordinate2D
    }

    var body: some View {
        let annotation = [IdentifiablePlace(location: position)]
        
        VStack(spacing: 20.0) {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("店名")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                TextField("請輸入店名", text: $placeContent.name)
                    .font(.body)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                )
            }
            
            VStack(alignment: .leading, spacing: 10.0) {
                Text("地點")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                TextField("請輸入地址", text: $placeContent.address)
                    .font(.body)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                )
            }
            
            Map(coordinateRegion: $region, annotationItems: annotation) {item in
                MapMarker(coordinate: item.location, tint: Color.red)
            }
                .cornerRadius(20)
                .frame(height: 150)
                .onAppear {
                    position = CLLocationCoordinate2D(latitude: placeContent.latitude,
                                                      longitude: placeContent.longitude)
                    region = MKCoordinateRegion(
                        center: position,
                        latitudinalMeters: 150,
                        longitudinalMeters: 150
                    )
                }
            
            VStack(alignment: .leading, spacing: 10.0) {
                Text("心得")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                TextField("請輸入內容", text: $placeContent.content)
                    .font(.body)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                )
            }
            
            HStack {
                Button{
                    print("取消")
                } label: {
                    HStack {
                        Text("取消")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(20.0)
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.bold)
                }
                
                Button{
                    print("儲存")
                } label: {
                    HStack {
                        Text("儲存")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("設置顏色淺"))
                    .cornerRadius(20.0)
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.bold)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaceView(placeContent: (PersistenceController.testData?.first)!)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

