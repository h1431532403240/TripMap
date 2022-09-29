//
//  ListView.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/3/25.
//
import SwiftUI

let noneImageView: some View = qusetionView()

struct ListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Site.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Site.time, ascending: false)])
    var Sites: FetchedResults<Site>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Sites.indices, id: \.self) { place in
                    ZStack {
                        NavigationLink(destination: PlaceView(placeContent: Sites[place])) {
                            EmptyView()
                        }
                        .opacity(0)
                        someList(place: Sites[place])
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    context.delete(Sites[place])
                                    do {
                                        try context.save()
                                    } catch {
                                        print(error)
                                    }
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
            }
            .navigationTitle("儲存地點")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("關閉")
                    }
                }
            }
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
