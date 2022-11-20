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
import PhotosUI

struct PlaceView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
        
    @ObservedObject var placeContent: Site
    @State var site = SiteViewModel()
    
    @State private var selectedItem: PhotosPickerItem?
        
    @State var cancel: Bool = false
    
    @State var add: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20.0) {
                
                // 圖片顯示、選擇
                ZStack(alignment: .bottomTrailing) {

                    Image(uiImage: (UIImage(data: site.coverImage) ?? UIImage(named: "Cat"))!)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("選擇圖片", systemImage: "photo")
                            .foregroundColor(.white)
                    }
                    .tint(.black)
                    .controlSize(.regular)
                    .buttonStyle(.bordered)
                    .cornerRadius(100)
                    .padding(8)
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                site.coverImage = data
                            }
                        }
                    }
                }
                .cornerRadius(20)
                .frame(height: 200)


                Text(site.time.toFormatterString())
                
                MixTextField(label: "店名", textFieldLabel: "請輸入店名", context: $site.name)
                MixTextField(label: "地點", textFieldLabel: "請輸入地址", context: $site.address)
                
                MiniMap(placeContent: placeContent)
                    .cornerRadius(20)
                    .frame(height: 150)
                
                MixTextField(label: "心得", textFieldLabel: "請輸入內容", context: $site.content)
                
                // 底部按鍵
                HStack {
                    Button{
                        self.cancel = true
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
                    .alert(isPresented: $cancel) {
                        Alert(title: Text("確定要離開此頁面？"),
                              message: Text("未儲存將會丟失資料。"),
                              primaryButton: .default(
                                Text("確定"),
                                action: {
                                    // 如果沒有新增資料，將不會儲存資料。
                                    if !context.hasChanges {
                                        if add {
                                            context.delete(placeContent)
                                            do{
                                                try context.save()
                                                print("刪除資料")
                                            } catch {
                                                print(error)
                                            }
                                        }
                                    } else {
                                        print("有新增資料")
                                    }
                                    dismiss()
                                }
                              ),
                              secondaryButton: .destructive(
                                Text("取消"),
                                action: {}
                              )
                        )
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
        .onAppear {
            site.address = placeContent.address
            site.content = placeContent.content
            site.coverImage = placeContent.coverImage
            site.id = placeContent.id
            site.latitude = placeContent.latitude
            site.longitude = placeContent.longitude
            site.name = placeContent.name
            site.star = placeContent.star
            site.time = placeContent.time
        }
        .toolbar(.hidden)
    }
    
    private func save() {
        placeContent.address = site.address
        placeContent.content = site.content
        placeContent.coverImage = site.coverImage
        placeContent.id = site.id
        placeContent.latitude = site.latitude
        placeContent.longitude = site.longitude
        placeContent.name = site.name
        placeContent.star = site.star
        placeContent.time = site.time
        
        if context.hasChanges {
            do{
                try context.save()
            } catch {
                print(error)
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

extension Date {
    func toFormatterString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        
        return dateFormatter.string(from: self)
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

