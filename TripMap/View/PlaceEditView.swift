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
import Alamofire

struct PlaceEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @State var contentDidChang: Bool = false
    
    @State var getAddressState: Bool = false
    
    @State var isUrlEmpty: Bool = false
    
    @State var checkUserSetting: Bool = false
    
    @StateObject var placeContent: SiteViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    
    @State var cancel: Bool = false
    
    @State var add: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading ,spacing: 20.0) {
                
                // 上半部
                Group {
                    // 圖片顯示、選擇
                    ZStack(alignment: .bottomTrailing) {
                        
                        Image(uiImage: (UIImage(data: placeContent.coverImage) ?? UIImage(named: "Cat"))!)
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
                                    placeContent.coverImage = data
                                }
                            }
                        }
                    }
                    .cornerRadius(20)
                    .frame(height: 200)
                    
                    HStack {
                        Spacer()
                        Text(placeContent.time.toFormatterString())
                        Spacer()
                    }
                                    
                    MixTextField(label: "店名", textFieldLabel: "請輸入店名", context: $placeContent.name)
                    
                    Text("星級")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack(alignment: .center, spacing: 20.0) {
                        Spacer()
                        ForEach((1...5), id: \.self) { count in
                            let star = placeContent.star
                            if star >= count {
                                Button {
                                    placeContent.star = Int64(count)
                                } label: {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(Color("設置顏色深"))
                                }
                            } else {
                                Button {
                                    placeContent.star = Int64(count)
                                } label: {
                                    Image(systemName: "star")
                                }
                            }
                        }
                        Spacer()
                    }
                    .font(.largeTitle)
                }
                
                // HackMD區塊
                Group {
                    HStack {
                        Text("HackMD")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Button {
                            if placeContent.hackMDUrl == "" {
                                
                                if UserDefaults.standard.object(forKey: "hackMDAPIToken") == nil ||
                                    UserDefaults.standard.object(forKey: "RPermission") == nil ||
                                    UserDefaults.standard.object(forKey: "WPermission") == nil ||
                                    UserDefaults.standard.object(forKey: "CPermission") == nil {
                                    checkUserSetting = true
                                } else {
                                    guard let url = UserDefaults.standard.string(forKey: "hackMDAPIToken") else { return }
                                    guard let rp = UserDefaults.standard.string(forKey: "RPermission") else { return }
                                    guard let wp = UserDefaults.standard.string(forKey: "WPermission") else { return }
                                    guard let cp = UserDefaults.standard.string(forKey: "CPermission") else { return }
                                    
                                    let headers: HTTPHeaders = [
                                        "Authorization": "Bearer \(url)"
                                    ]
                                    let parameters: [String : String] = [
                                        "title" : "\(placeContent.name)",
                                        "content": "\(placeContent.content)",
                                        "readPermission": "\(rp)",
                                        "writePermission": "\(wp)",
                                        "commentPermission": "\(cp)"
                                    ]
                                    AF.request("https://api.hackmd.io/v1/notes", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                                        .responseDecodable(of: UploadHackMDResult.self) { response in
                                            switch response.result {
                                            case .success(let result):
                                                placeContent.hackMDUrl = result.publishLink
                                            case .failure(let error):
                                                print(error)
                                            }
                                        }
                                }
                            } else {
                                isUrlEmpty = true
                            }
                            
                        } label: {
                            Label("分享", systemImage: "square.and.arrow.up.circle.fill")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8.0)
                                .background(Color("設置顏色深"))
                                .cornerRadius(20)
                                .foregroundColor(.white)
                        }
                        .alert(
                            Text("請檢查內容"),
                            isPresented: $isUrlEmpty
                        ) {
                            Button("ok") {
                                isUrlEmpty = false
                            }
                        } message: {
                            Text("請檢查HackMD欄位內網址是否有需要使用，若要重新上傳內容請清空網址，並再次點擊「分享」按鍵。")
                        }
                        
                        .alert(
                            Text("請檢查使用者設定"),
                            isPresented: $checkUserSetting
                        ) {
                            Button("ok") {
                                checkUserSetting = false
                            }
                        } message: {
                            Text("請檢查使用者設定中，HackMD欄位是否都有設置，並且按下「儲存」。")
                        }
                        
                        // 複製網址按鍵
                        Button {
                            UIPasteboard.general.string = placeContent.hackMDUrl
                        } label: {
                            Label("複製網址", systemImage: "list.clipboard.fill")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8.0)
                                .background(Color("設置顏色深"))
                                .cornerRadius(20)
                                .foregroundColor(.white)
                        }
                    }
                    
                    TextField("請輸入網址", text: $placeContent.hackMDUrl)
                        .font(.body)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color(.systemGray4), lineWidth: 2)
                        )
                }
                    
                // 地點板塊
                Group {
                    HStack {
                        Text("地點")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Button {
                            Task {
                                guard let placemark = try? await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: placeContent.latitude, longitude: placeContent.longitude)) else { getAddressState = true; return }
                                //                        guard (placemark.first?.getFullAddress()) != nil else { getAddressState = true; return }
                                placeContent.address = placemark.first?.getFullAddress() ?? ""
                                if placeContent.address == "" {
                                    getAddressState = true
                                }
                            }
                        } label: {
                            Label("獲取地址", systemImage: "123.rectangle.fill")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8.0)
                                .background(Color("設置顏色深"))
                                .cornerRadius(20)
                                .foregroundColor(.white)
                        }
                        .alert(
                            Text("獲取地址失敗"),
                            isPresented: $getAddressState
                        ) {
                            Button("ok") {
                                getAddressState = false
                            }
                        } message: {
                            Text("請手動輸入地址。")
                        }
                    }
                    
                    TextField("請輸入地址", text: $placeContent.address)
                        .font(.body)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color(.systemGray4), lineWidth: 2)
                        )

                }
                
                MiniMap(placeContent: placeContent)
                    .cornerRadius(20)
                    .frame(height: 150)
                
                // 心得板塊
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("心得")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    ZStack(alignment: .bottomTrailing) {
                        TextEditor(text: $placeContent.content)
                            .frame(height: 300.0)
                            .border(Color.gray, width: 1.5)

                        NavigationLink(destination: MarkDownEditorView(text: $placeContent.content)) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .foregroundColor(.black)
                                .font(.title2)
                                .padding(4.7)
                                .background(Color.white)
                                .border(.black, width: 1.5)
                        }
                        .padding(20)
                    }
                }
                
                // 底部按鍵
                HStack {
                    Button{
                        self.cancel = true
                    } label: {
                        Text("取消")
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
                        Text("儲存")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("設置顏色淺"))
                            .cornerRadius(20.0)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding()
        }
        .toolbar(.hidden)
    }
    
    private func save() {
        
        var site = Site()
        
        //        let fetchSite: NSFetchRequest<Site> = Site.fetchRequest()
        let fetchSite = NSFetchRequest<NSFetchRequestResult>(entityName: "Site")
        fetchSite.predicate = NSPredicate(format: "id = %@", placeContent.id as String)
        
        let results = try? context.fetch(fetchSite)
        
        if results?.count == 0 {
            site = Site(context: context)
        } else {
            site = results?.first as! Site
        }
        
        site.address = placeContent.address
        site.content = placeContent.content
        site.coverImage = placeContent.coverImage
        site.id = placeContent.id
        site.latitude = placeContent.latitude
        site.longitude = placeContent.longitude
        site.name = placeContent.name
        site.star = placeContent.star
        site.time = placeContent.time
        
        do {
            try context.save()
        } catch {
            print("儲存失敗")
        }
    }
}

struct MiniMap: View {
    
    let placeContent: SiteViewModel
    
    @State private var position: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion
    
    struct IdentifiablePlace: Identifiable {
        let id = UUID()
        let location: CLLocationCoordinate2D
    }
    
    init(placeContent: SiteViewModel) {
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

struct UploadHackMDResult: Decodable {
    let publishLink: String
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaceEditView(placeContent: SiteViewModel(site: (PersistenceController.testData?.first)!))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

