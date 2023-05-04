//
//  LocationMapAnnotationView.swift
//  SwiftfulMapApp
//
//  Created by Nick Sarno on 11/28/21.
//

import SwiftUI
import MapKit

struct LocationMapAnnotationView: View {
    @State private var isClickAnnotation: Bool = false
    @State private var isClickCheckButton: Bool = false
    @StateObject var placeContent: SiteViewModel
    
    let accentColor = Color("AccentColor")
    
    var body: some View {
        ZStack {
            Button {
                isClickAnnotation.toggle()
            } label: {
                ZStack {
                    VStack(spacing: 0) {
                        Image(systemName: "map.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(accentColor)
                            .clipShape(Circle())
                        
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(accentColor)
                            .frame(width: 10, height: 10)
                            .rotationEffect(Angle(degrees: 180))
                            .offset(y: -3)
                            .padding(.bottom, 40)
                    }
                    .shadow(radius: 10)
                }
            }
            if isClickAnnotation {
                ZStack {
                    VStack {
                        Text(placeContent.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                        HStack {
                            Spacer()
                            // 查看按鈕
                            Button {
                                isClickCheckButton = true
                            } label: {
                                Label("查看", systemImage: "eye.fill")
                                    .padding(10)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                            .sheet(isPresented: $isClickCheckButton) {
                                PlaceEditView(placeContent: placeContent)
                                    .interactiveDismissDisabled()
                            }
                            Spacer()
                            // 導航按鈕
                            Button {
                                let coords = CLLocationCoordinate2DMake(placeContent.latitude, placeContent.longitude)
                                
                                let place = MKPlacemark(coordinate: coords)
                                
                                let mapItem = MKMapItem(placemark: place)
                                mapItem.name = placeContent.name
                                mapItem.openInMaps(launchOptions: nil)
                            } label: {
                                Label("導航", systemImage: "location.circle.fill")
                                    .padding(10)
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        Button {
                            isClickAnnotation = false
                        } label: {
                            Image(systemName: "xmark")
                                .fontWeight(.heavy)
                                .font(.title3)
                                .padding(6)
                                .foregroundColor(.white)
                                .background(.gray)
                                .cornerRadius(100.0)
                                .padding([.trailing], 5.0)
                        }
                    }
                }
                .frame(width: 220, height: 125)
                .background(.white)
                .offset(y: -115)
            }
        }
    }
}

struct LocationMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            LocationMapAnnotationView(placeContent: SiteViewModel(site: (PersistenceController.testData?.first)!))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
