//
//  ListView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/25.
//
import SwiftUI

let noneImageView: some View = qusetionView()

struct ListView: View {
    
    @FetchRequest(
        entity: Sites.entity(),
        sortDescriptors: [])
    var Site: FetchedResults<Sites>
    
//    @State var something = [
//        Site(image: ["https"], name: "豚戈屋台", star: 1),
//        Site(image: ["https://i.imgur.com/k5L85MH.jpeg"], name: "阿比", star: 2)
//    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Site.indices, id: \.self) { place in
                    ZStack {
                        NavigationLink(destination: PlaceView(placeContent: Site[place])) {
                            EmptyView()
                        }
                        .opacity(0)
                        someList(place: Site[place])
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
        NavigationView {
            ListView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

struct someList: View {
    
    var place: Sites
    var body: some View {
        HStack {
            VStack {
                if let imageData = place.coverImage {
                    Image(uiImage: UIImage(data: imageData) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(25)
                } else {
                    noneImageView
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
