//
//  SomeView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/28.
//

import Foundation
import SwiftUI

public func qusetionView() -> some View {
    return ZStack {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 80, height: 80)
            .foregroundColor(Color("SystemColorReverse"))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color("SystemColor"), lineWidth: 5)
            )
        Image(systemName: "questionmark")
            .font(Font.system(size: 50, weight: .semibold))
    }
}
