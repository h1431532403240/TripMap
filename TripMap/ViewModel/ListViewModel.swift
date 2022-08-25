//
//  ListViewModel.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/8/13.
//

import Combine

class ListViewModel: ObservableObject {
    @Published var Lists: [Site] = []
}
