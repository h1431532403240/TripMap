//
//  PlaceView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/27.
//

import SwiftUI
import MapKit
import UIKit
import CoreData

struct PlaceView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @State var placeContent: Site
    
    @State private var position = CLLocationCoordinate2D(latitude: 0.0,
                                                longitude: 0.0)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0,
                                       longitude: 0.0),
        latitudinalMeters: 200,
        longitudinalMeters: 200
    )

    var update: Bool = false
    
    var add: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20.0) {
                MixTextField(label: "店名", textFieldLabel: "請輸入店名", context: $placeContent.name)
                MixTextField(label: "地點", textFieldLabel: "請輸入地址", context: $placeContent.address)
                MixTextField(label: "心得", textFieldLabel: "請輸入內容", context: $placeContent.content)
                
                MiniMap(placeContent: placeContent)
                    .cornerRadius(20)
                    .frame(height: 150)
                
                HStack {
                    Button{
                        dismiss()
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
                        save()
                        dismiss()
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
    private func save() {        
        if update {
            let fetchRequestRead = NSFetchRequest<Site>(entityName: "Site")
            fetchRequestRead.fetchLimit = 1
            fetchRequestRead.predicate = NSPredicate(format: "id == %@", placeContent.id)
            
            do{
                let siteUpdate = try context.fetch(fetchRequestRead)
                
                siteUpdate[0].name = placeContent.name
                siteUpdate[0].coverImage = placeContent.coverImage
                siteUpdate[0].address = placeContent.address
                siteUpdate[0].content = placeContent.content
                siteUpdate[0].longitude = placeContent.longitude
                siteUpdate[0].latitude = placeContent.latitude
                siteUpdate[0].id = placeContent.id
                siteUpdate[0].star = placeContent.star
                siteUpdate[0].time = placeContent.time
                
                do{
                    try context.save()
                    print("更新資料")
                } catch let createError{
                    print("Failed to update: \(createError)")
                }

            } catch let fetchError{
                print("Failed to fetch compaies: \(fetchError)")
            }
        } else {
            
            let _site = NSEntityDescription.insertNewObject(forEntityName: "Site", into: context) as! Site

            _site.name = placeContent.name
            _site.coverImage = placeContent.coverImage
            _site.address = placeContent.address
            _site.content = placeContent.content
            _site.longitude = placeContent.longitude
            _site.latitude = placeContent.latitude
            _site.id = placeContent.id
            _site.star = placeContent.star
            _site.time = placeContent.time

            do{
                try context.save()
                print("新增資料")
            }catch let createError{
                print("Failed to create :\(createError)")
            }
        }
    }
}

struct MiniMap: View {

    let placeContent: Site

    @State private var position: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion
    
    struct IdentifiablePlace: Identifiable {
        let id = UUID()
        let location: CLLocationCoordinate2D
    }

    init(placeContent: Site) {
        self.placeContent = placeContent

        let position = CLLocationCoordinate2D(latitude: placeContent.latitude, longitude: placeContent.longitude)
        let region = MKCoordinateRegion(
            center: position,
            latitudinalMeters: 200,
            longitudinalMeters: 200
        )

        self._position = State(initialValue: position)
        self._region = State(initialValue: region)
    }

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [], annotationItems: [IdentifiablePlace(location: position)]) {item in
            MapMarker(coordinate: item.location, tint: Color.red)
        }
    }

}

struct MixTextField: View {
    let label: String
    let textFieldLabel: String
    
    @Binding var context: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(label)
                .font(.largeTitle)
                .fontWeight(.bold)
            TextField(textFieldLabel, text: $context)
                .font(.body)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(.systemGray4), lineWidth: 2)
            )
        }
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

