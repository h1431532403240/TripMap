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
        entity: Site.entity(),
        sortDescriptors: [])
    var Sites: FetchedResults<Site>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Sites.indices, id: \.self) { place in
                    ZStack {
                        NavigationLink(destination: PlaceView(placeContent: Sites[place], update: true)) {
                            EmptyView()
                        }
                        .opacity(0)
                        someList(place: Sites[place])
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
    
    var place: Site
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
                print("編輯")
            } label: {
                Label("編輯", systemImage: "square.and.pencil")
            }
            .tint(Color("設置顏色深"))
        }
        
    }
}
