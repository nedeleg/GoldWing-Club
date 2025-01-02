//
//  EventEditRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/27/24.
//

import SwiftUI

struct EventEditRow: View {
    var event: Event

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                Text(dateFormatter.string(from: event.date) )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            Spacer()
            Button(action: {
                // Ensure selectedContact is set first
                // selectedEvent = event
            }) {
                Image(systemName: "pencil").foregroundColor(.red) // Edit icon
            }
        }



    }
}

/*
#Preview {
    EventEditRow()
}
*/
