//
//  PlaceView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/27.
//

import SwiftUI

struct PlaceView: View {
    @State var placeContent: Site

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("店名")
                    .font(.system(size: 40, weight: .bold))
                TextField("請輸入店名", text: $placeContent.name)
                    .font(.system(size: 20, weight: .semibold))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                )
            }
            
            VStack(alignment: .leading, spacing: 10.0) {
                Text("地點")
                    .font(.system(size: 40, weight: .bold))
                TextField("請輸入店名", text: $placeContent.name)
                    .font(.system(size: 20, weight: .semibold))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                )
            }
            Spacer()
        }
        .padding()
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(placeContent: Site(image: ["https"], name: "豚戈屋台", star: 1))
    }
}

