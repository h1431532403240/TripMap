//
//  PlaceViwePageView.swift
//  TripMap
//
//  Created by 廖家慶 on 2023/4/30.
//

import SwiftUI
import MarkdownUI

struct PlaceViwePageView: View {
    var text: String
    var title: String
    var body: some View {
        ScrollView {
            Markdown(text)
                .markdownTheme(.gitHub)
                .padding(.horizontal, 20.0)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct PlaceViwePageView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceViwePageView(text: PersistenceController.testData?.first!.content ?? "", title: PersistenceController.testData?.first!.name ?? "")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
