//
//  ContactEditRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/31/24.
//

import SwiftUI

struct ContactEditRow: View {
    var contact: Contact

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contact.fullName)
                    .font(.headline)

                Text(contact.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            Spacer()
            Button(action: {
                // Ensure selectedContact is set first
                // selectedInfo = info
            }) {
                Image(systemName: "pencil").foregroundColor(.red) // Edit icon
            }
        }
    }
}

/*
#Preview {
    ContactEditRow()
}
*/
