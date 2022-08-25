//
//  ListView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/25.
//
import SwiftUI

struct ListView: View {
    
    @State var something = [
        Site(image: ["https"], name: "豚戈屋台", star: 1),
        Site(image: ["https://i.imgur.com/k5L85MH.jpeg"], name: "阿比", star: 2)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(something.sorted(by: <), id: \.id) { place in
                    ZStack {
                        NavigationLink(destination: PlaceView(placeContent: place)) {
                            EmptyView()
                        }
                        .opacity(0)
                        someList(place: place)
                    }
                }
            }
            .navigationTitle("儲存地點")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

struct noneImageView: View {
    var body: some View {
        ZStack {
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
}

struct someList: View {
    var place: Site
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: place.image[0]!)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(25)
                    } else if phase.error != nil {
                        noneImageView()
                    } else {
                        noneImageView()
                    }
                }
            }
            .padding([.top, .bottom], 5.0)
            VStack(alignment: .leading) {
                Text("\(place.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10.0)
                HStack {
                    ForEach((1...5), id: \.self) { count in
                        let star = place.star
                        if star >= count {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color("設置顏色深"))
                        } else {
                            Image(systemName: "star")
                        }
                    }
                }
                .font(.title2)
            }
            .padding()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                print("刪除")
            } label: {
                Label("刪除", systemImage: "trash")
            }
            .tint(.red)
            Button {
                print("導航")
            } label: {
                Label("導航", systemImage: "location.fill")
            }
            .tint(Color("設置顏色深"))
        }
        
    }
}
