//
//  UserSettingView.swift
//  TripMap
//
//  Created by 廖家慶 on 2023/5/4.
//

import SwiftUI

struct UserSettingView: View {
    @Environment(\.dismiss) var dismiss
    @State var hackMDAPIToken: String = ""
    
    enum RWPermission: String, CaseIterable, Identifiable {
        case owner = "owner"
        case signed_in = "signed_in"
        case guest = "guest"
        var id: Self { self }
    }
    
    enum CommentPermission: String, CaseIterable, Identifiable {
        case disabled  = "disabled"
        case forbidden = "forbidden"
        case owners = "owners"
        case signed_in_users = "signed_in_users"
        case everyone = "everyone"
        var id: Self { self }
    }
    
    @State private var RPermission: RWPermission = .owner
    @State private var WPermission: RWPermission = .owner
    @State private var CPermission: CommentPermission = .disabled
    @State private var iCloudButton: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20.0) {
                    // 輸入HackMD API Token
                    Group {
                        Text("HackMD API Token")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        TextField("請輸入API Tokan", text: $hackMDAPIToken)
                            .font(.body)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color(.systemGray4), lineWidth: 2)
                            )
                    }
                    
                    // 選擇HackMD閱讀權限
                    Group {
                        Text("HackMD閱讀權限")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Picker("R_Permission", selection: $RPermission) {
                            ForEach(RWPermission.allCases) { permission in
                                Text(permission.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // 選擇HackMD寫入權限
                    Group {
                        Text("HackMD寫入權限")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Picker("W_Permission", selection: $WPermission) {
                            ForEach(RWPermission.allCases) { permission in
                                Text(permission.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // 選擇HackMD留言權限
                    Group {
                        Text("HackMD留言權限")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Picker("C_Permission", selection: $CPermission) {
                            ForEach(CommentPermission.allCases) { permission in
                                Text(permission.rawValue.capitalized)
                            }
                        }
                        .tint(.white)
                        .pickerStyle(.menu)
                        .background(Color.gray)
                        .cornerRadius(5.0)
                    }
                    
                    Spacer()
                    
                    HStack() {
                        Spacer()
                        Button {
                            UserDefaults.standard.set(hackMDAPIToken, forKey:"hackMDAPIToken")
                            UserDefaults.standard.set(RPermission.rawValue, forKey:"RPermission")
                            UserDefaults.standard.set(WPermission.rawValue, forKey:"WPermission")
                            UserDefaults.standard.set(CPermission.rawValue, forKey:"CPermission")
                            UserDefaults.standard.set(iCloudButton, forKey:"iCloudButton")
                        } label: {
                            Text("儲存")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("設置顏色深"))
                                .cornerRadius(20.0)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                }
                .padding()
                
            }
            .onAppear {
                if let url = UserDefaults.standard.string(forKey: "hackMDAPIToken") { hackMDAPIToken = url }
                if let rp = UserDefaults.standard.string(forKey: "RPermission") { RPermission = RWPermission(rawValue: rp) ?? RWPermission(rawValue: "owner")! }
                if let wp = UserDefaults.standard.string(forKey: "WPermission") { WPermission = RWPermission(rawValue: wp) ?? RWPermission(rawValue: "owner")! }
                if let cp = UserDefaults.standard.string(forKey: "CPermission") { CPermission = CommentPermission(rawValue: cp) ?? CommentPermission(rawValue: "disabled")! }
                if let ib = UserDefaults.standard.object(forKey: "iCloudButton") { iCloudButton = ib as? Bool ?? false }
            }
            .navigationTitle("使用者設定")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
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
}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
    }
}
