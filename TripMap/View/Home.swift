//
//  Home.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import SwiftUI
import CoreLocation
import CoreData

struct Home: View {
    
    @StateObject var mapData = MapViewModel()
    
    @Environment(\.managedObjectContext) var context
        
    @State var locationManager = CLLocationManager()
    
    @State var isEditing = false
    
    @State private var ListViewSheet = false

    @State private var PlaceViewSheet = false
    
    var body: some View {
        
        ZStack {
            
            // 地圖顯示
            MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            // 搜尋列
            VStack() {
                searchBar(mapData: mapData, isEditing: isEditing)
                Spacer()
            }
            .padding()
            
            Image(systemName: "pin.fill")
                .foregroundColor(.red)
            
            VStack {
                
                Spacer()
                
                // 調整定位、切換地圖按鈕
                VStack(spacing: 5.0) {
                    
                    // 測試按鈕
                    Button(action: {
                        
                    }) {
                        Image(systemName: "hammer")
                            .font(.title2)
                            .padding(4.7)
                            .background(Color.white)
                            .cornerRadius(10.0)
                    }
                    
                    // 切換地圖按鈕
                    Button(action: mapData.updateMapType) {
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(4.7)
                            .background(Color.white)
                            .cornerRadius(10.0)
                    }
                    
                    // 返回使用者定位按鈕
                    Button(action: mapData.currentLocation) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10.0)
                        
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
                // 底部選單列
                HStack() {
                    // 列表
                    Button(action:{
                        self.ListViewSheet = true
                    }, label: {
                        Image(systemName: "list.bullet.rectangle")
                    })
                        .frame(maxWidth: .infinity)

                    Text("")
                        .frame(maxWidth: .infinity)
                    
                    // 個人頁面
                    Button(action:{}, label: {
                        Image(systemName: "person.circle")
                    })
                        .frame(maxWidth: .infinity)

                }
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
                .sheet(isPresented: $ListViewSheet) {
                    ListView()
                        .interactiveDismissDisabled()
                }

                // 「設置」button
                .overlay(
                    Button(action:{
                        self.PlaceViewSheet = true
                    }, label: {
                        VStack(spacing: 5.0) {
                            Text("設   置")
                                .font(.body)
                                .fontWeight(.bold)

                            Image(systemName: "list.bullet")
                                .font(.system(size: 50.0, weight: .bold))
                        }
                        .shadow(radius: 0, x: 2.0, y: 2.0)
                        .padding(20.0)
                        .foregroundColor(Color.white)
                    })
                        .background(LinearGradient(gradient: Gradient(colors: [Color("設置顏色淺"), Color("設置顏色深")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Circle())
                        .offset(y: -40.0)
                )
                .frame(maxWidth: .infinity)
                .background(.white)
                .sheet(isPresented: $PlaceViewSheet) {
                    PlaceView(placeContent: SavePlace(), add: true)
                    .interactiveDismissDisabled()
                }
                
            }
            
        }
        
        // 開啟ZStack時運作
        .onAppear(perform: {
            
            // 設置委託
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
            
        })
        
        // 處理拒絕定位權限
        .alert(isPresented: $mapData.permissionDenied) {
            
            Alert(title: Text("需要定位權限"), message: Text("請至設定 -> TripMap，將「位置」功能開啟。"), dismissButton: .default(Text("前往設定")) {
                
                // 將使用者跳到設置頁面
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                
            })
        }
        
        // 當搜索文字變動時搜尋
        .onChange(of: mapData.searchText, perform: { value in
            
            // 設置延遲時間避免重複搜尋
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if value == mapData.searchText {
                    self.mapData.searchPlace()
                }
                
            }
        })
    }
    
    private func SavePlace() -> Site {
        let site = NSEntityDescription.insertNewObject(forEntityName: "Site", into: context) as! Site
        
        let longitude = mapData.mapView.centerCoordinate.longitude
        let latitude = mapData.mapView.centerCoordinate.latitude
                
//        mapData.getAddress(location: CLLocation(latitude: latitude, longitude: longitude)) { (address) in
//            site.address = address
//            print(site.address)
//        }
                
        site.address = mapData.address
        site.id = UUID().uuidString
        site.longitude = longitude
        site.latitude = latitude
        site.coverImage = UIImage(named: "Cat")!.pngData()!
        site.time = Date()
        site.name = ""
        site.star = 0
        site.content = ""
        
        
        print(site)

        return site
    }
}

extension View {
    
    // 關閉鍵盤
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// 搜尋列實作
struct searchBar: View {
    
    @StateObject var mapData: MapViewModel
    
    @State var isEditing: Bool
    
    var body: some View {
        VStack {
            // 搜尋列
            TextField("想設置的地點？", text: $mapData.searchText)
                .colorScheme(.light)
                .padding()
                .background(.white)
                .cornerRadius(25)
                .shadow(radius: 3, x: 2.0, y: 2.0)
                .overlay(
                    HStack {
                        Spacer()
                        if isEditing {
                            Button(action: {
                                self.isEditing = false
                                self.mapData.searchText = ""
                                hideKeyboard()
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8.0)
                            }
                            .frame(alignment: .trailing)
                        }
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(alignment: .trailing)
                            .padding(.trailing)
                    }
                )
                .font(.headline.bold())
                .onTapGesture { self.isEditing = true }
            
            // 顯示搜尋結果
            if !mapData.places.isEmpty && mapData.searchText != "" {
                ScrollView {
                    VStack(spacing: 15){
                        ForEach(mapData.places){place in
                            
                            VStack {
                                Text(place.place.name ?? "")
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                Text(place.place.getFullAddress() ?? "")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                            }
                            .onTapGesture {
                                mapData.selectPlace(place: place)
                                hideKeyboard()
                            }
                            
                            Divider()
                        }
                    }
                    .padding(.top)
                }
                .background(.white)
            }
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Home()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
