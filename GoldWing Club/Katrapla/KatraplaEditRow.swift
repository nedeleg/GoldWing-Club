//
//  KatraplaEditRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct KatraplaEditRow: View {
    @State var katrapla: Katrapla

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(katrapla.title)
                    .font(.headline)
                Text(dateFormatter.string(from: katrapla.date) )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            Spacer()
            Button(action: {
                // Ensure selectedContact is set first
                // selectedInfo = info
            }) {
                Image(systemName: "pencil")
                    .foregroundColor(.red) // Edit icon
            }
        }
    }
}

#Preview {
    KatraplaEditRow (katrapla: Katrapla (
        id: "0",
        title: "Katrapla 001 - 1981",
        url_source : "https://www.calameo.com/books/00452690731446eb43436",
        photo : "https://i.calameoassets.com/170504202135-b1a2708eada340fbd36ecab29923a2c8/large.jpg",
        date: Date()

    ))
}
