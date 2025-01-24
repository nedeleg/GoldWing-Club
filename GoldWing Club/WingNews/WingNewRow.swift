//
//  WingNewRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct WingNewRow: View {
    @State var wingNew: WingNew

    var body: some View {
        HStack {
            if let url = URL(string: wingNew.photo) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .scaledToFit()
                }
                .frame(width: 40)
            }
            
            VStack(alignment: .leading) {
                Text(wingNew.title)
                    .font(.headline)
                
                Text(frenchDateFormatter.string(from: wingNew.date) )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    WingNewRow (wingNew: WingNew (
        id: "0",
        numero: "1",
        title: "Gold News Avril 1987",
        url_source : "https://www.calameo.com/books/004526907a1cd0f6663ff",
        photo : "https://i.calameoassets.com/201229194556-a8c542e90e42d34f8f840d3b20f6b535/large.jpg",
        date: Date()
        ))
}
