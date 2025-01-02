//
//  ContactRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

struct ContactRow: View {
    var contact: Contact
    
    var body: some View {
        HStack {
            if let url = URL(string: contact.photo) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .scaledToFit()
                .frame(height: 40)
                .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(contact.fullName)
                    .font(.headline)

                Text(contact.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 0)
    }
}

/*
 #Preview {
 ContactRow()
 }
*/
