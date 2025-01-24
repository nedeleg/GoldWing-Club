//
//  WingNewDetailView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct WingNewDetailView: View {
    @State var wingNew: WingNew

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WingNewDetailView (wingNew: WingNew (
        id: "0",
        numero : "1",
        title: "Gold News Avril 1987",
        url_source : "https://www.calameo.com/books/004526907a1cd0f6663ff",
        photo : "https://i.calameoassets.com/201229194556-a8c542e90e42d34f8f840d3b20f6b535/large.jpg",
        date: Date()
        ))
}
