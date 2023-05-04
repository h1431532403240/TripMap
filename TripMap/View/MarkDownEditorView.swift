//
//  MarkDownEditorView.swift
//  TripMap
//
//  Created by 廖家慶 on 2023/4/27.
//

import SwiftUI
import Alamofire
import PhotosUI

struct MarkDownEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String
    @FocusState private var markDownEditorIsFocused: Bool
    @State private var selectedItem: PhotosPickerItem?
    @State private var uploadImageFailed = false
    @State private var uploadImageProgress: Double = 0.0
    @State private var isUploadImageProgressViewShowing = false
    
    var body: some View {
        ZStack {
            if isUploadImageProgressViewShowing {
                ZStack(alignment: .center) {
                    Color.gray
                        .ignoresSafeArea()
                    Text("\(Int(uploadImageProgress * 100))%")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                    
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 10)
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .trim(from: 0, to: uploadImageProgress)
                        .stroke(Color.green, lineWidth: 10)
                        .frame(width: 150, height: 150)
                        .rotationEffect(Angle(degrees: -90))
                }
                .zIndex(1)
            }
            
            VStack(spacing: 0) {
                TextEditor(text: $text)
                    .focused($markDownEditorIsFocused)
                    .offset(y: 30.0)
                    .padding(20)

                                
                Spacer()
                
                // 鍵盤快捷鍵
                if markDownEditorIsFocused {
                    ZStack {
                        HStack {
                            Spacer()
                            Button {
                                text += "#"
                            } label: {
                                keyboardShortcutView(symbol: "number")
                            }
                            Button {
                                text += "*"
                            } label: {
                                keyboardShortcutView(symbol: "staroflife.fill")
                            }
                            Button {
                                text += ">"
                            } label: {
                                keyboardShortcutView(symbol: "greaterthan")
                            }
                            Button {
                                text += "-"
                            } label: {
                                keyboardShortcutView(symbol: "minus")
                            }
                            Button {
                                text += "[標題](網址)"
                            } label: {
                                keyboardShortcutView(symbol: "link")
                            }
                            // 選擇圖片
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                keyboardShortcutView(symbol: "photo")
                            }
                            NavigationLink(destination: PlaceViwePageView(text: text, title: "預覽畫面")) {
                                keyboardShortcutView(symbol: "eye.fill")
                            }
                            // 上傳圖片
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    hideKeyboard()
                                    if let selectedImage = try? await newItem?.loadTransferable(type: Data.self) {
                                        let uploadImage = selectedImage.base64EncodedData()
                                        let headers: HTTPHeaders = [
                                            "Authorization": "Client-ID 704a39d58c7c067",
                                        ]

                                        AF.upload(multipartFormData: { data in
                                            isUploadImageProgressViewShowing = true
                                            let imageData = uploadImage
                                            data.append(imageData, withName: "image")
                                        }, to: "https://api.imgur.com/3/image", headers: headers)
                                        .responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { response in
                                            defer {
                                                DispatchQueue.main.async {
                                                    isUploadImageProgressViewShowing = false
                                                }
                                            }
                                            switch response.result {
                                            case .success(let result):
                                                print(result.data.link)
                                                text += "![圖片標題](\(result.data.link))"
                                            case .failure(let error):
                                                uploadImageFailed = true
                                                print(error)
                                            }
                                        }
                                        .uploadProgress { progress in

                                            uploadImageProgress = progress.fractionCompleted
                                            print("Upload Progress: \(progress.fractionCompleted)")
                                        }
                                    } else {
                                        uploadImageFailed = true
                                    }
                                }
                            }
                            .alert(isPresented: $uploadImageFailed) {
                                Alert(title: Text("上傳失敗！"), message: Text("相片損毀無法讀取。"))
                            }
                            Spacer()
                        }
                    }
                    .frame(height: 50.0)
                    .background(Color.gray, ignoresSafeAreaEdges: .top)
                }
            }
            .toolbar(.hidden)
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.heavy)
                        .font(.headline)
                        .padding(6)
                        .foregroundColor(.white)
                        .background(.gray)
                        .cornerRadius(100.0)
                        .padding([.top, .trailing], 20.0)
                }
            }
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct UploadImageResult: Decodable {
    struct Data: Decodable {
        let link: URL
    }
    let data: Data
}

struct keyboardShortcutView: View {
    
    var symbol: String
    
    var body: some View {
        Image(systemName: symbol)
            .fontWeight(.bold)
            .font(.title)
            .foregroundColor(.white)
            .frame(width: 45.0, height: 45.0)
            .background(Color(hex: 0x2F2D2E))
    }
}




struct MarkDownEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MarkDownEditorView(text: .constant(PersistenceController.testData?.first!.content ?? ""))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

