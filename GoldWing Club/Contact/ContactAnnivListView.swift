//
//  ContactAnnivListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/20/24.
//

import SwiftUI

struct ContactAnnivListView: View {
    @StateObject private var contactViewModel = ContactViewModel()

    var clubId : String     // Club to filter contact by ClubId

    var body: some View {
            VStack {
                List(contactViewModel.contacts) { contact in
                    NavigationLink(destination: ContactDetailView(contact: contact)) {
                        ContactRow(contact: contact)
                    }
                }
                .onAppear {
                    contactViewModel.loadMonthAnniversaries(for: clubId, for: Date.now)
                }
            }
            .navigationTitle("Anniversaires")
        Spacer()
    }
}

/*
#Preview {
    ContactAnnivListView()
}
*/
