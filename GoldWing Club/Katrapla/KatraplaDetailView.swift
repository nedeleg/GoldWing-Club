//
//  KatraplaDetailView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct KatraplaDetailView: View {
    @State var katrapla: Katrapla

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    KatraplaDetailView (katrapla: Katrapla (
        id: "0",
        numero : "1",
        title: "Katrapla 001 - 1981",
        url_source : "https://www.calameo.com/books/00452690731446eb43436",
        photo : "https://i.calameoassets.com/170504202135-b1a2708eada340fbd36ecab29923a2c8/large.jpg",
        date: Date()

    ))
}
