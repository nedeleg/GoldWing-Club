//
//  EventRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/20/24.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    
    var body: some View {
        HStack {
            if let url = URL(string: event.photo) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                
                Text("\(event.date)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EventRow(event: Event(
         id: "1",
         clubId: "String",
         eventType : "String",
         name: "String",
         date: try! Date("2022-02-14T20:15:00Z", strategy: .iso8601),
         description :"String",
         photo: "String",
         fichierInscription: "String",
         inscriptionForm: "String"
    ) )
}
