//
//  ContactClubListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/19/24.
//

import SwiftUI

struct ContactClubListView: View {
    @StateObject private var clubViewModel = ClubViewModel()
    @StateObject private var contactViewModel = ContactViewModel()
    
    
    var club: Club     // Club to filter contacts
    var role: String   // Role to filter contacts
    
    var body: some View {
        List( contactViewModel.filteredContacts ) { contact in
            NavigationLink(destination: ContactDetailView(contact: contact)) {
                ContactRow(contact: contact)
            }
        }
        .searchable(text: $contactViewModel.searchText, prompt: "Rechercher un contact")
        .navigationTitle("\(role.capitalized)")
        .onAppear {
            contactViewModel.loadContactsForClubAndRole (for: club.id, for: role)
        }
    }
}

/*
 #Preview {
 ContactClubListView()
 }
 */
