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
                
                Text(frenchDateHourFormatter.string(from: event.startDate) )
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
         startDate: Date(),
         endDate: Date().addingTimeInterval (TimeInterval( 60 )),
         createdBy: "Auteur",
         description :"String",
         photo: "String",
         fichierInscription: "String",
         inscriptionForm: "String"
    ) )
}
