//
//  KatraplaRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct KatraplaRow: View {
    @State var katrapla: Katrapla
    
    var body: some View {
        HStack {
            if let url = URL(string: katrapla.photo) {
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
                Text(katrapla.title)
                    .font(.headline)
                
                Text(frenchDateFormatter.string(from: katrapla.date) )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        
    }
}

#Preview {
    KatraplaRow (katrapla: Katrapla (
        id: "0",
        numero: "1",
        title: "Katrapla 001 - 1981",
        url_source : "https://www.calameo.com/books/00452690731446eb43436",
        photo : "https://i.calameoassets.com/170504202135-b1a2708eada340fbd36ecab29923a2c8/large.jpg",
        date: Date()
    ))
}
