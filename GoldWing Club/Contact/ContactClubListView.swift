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
    @EnvironmentObject var authViewModel: AuthViewModel

    
    var club: Club     // Club to filter contacts
    var role: String   // Role to filter contacts

    @State var mode: EditMode = .inactive //< -- Here

    var body: some View {
        VStack {
            if contactViewModel.isLoading {
                ProgressView("Chargement...")
            } else {
                List {
                    // List all the contacts (filtere by search) from the Database
                    ForEach(contactViewModel.filteredContacts) {contact in
                        if mode == .active {
                            // in Edit mode add the delete button and the pencil
                            // EditButton() does automatically the Delete Button
                            // We just have added the button to Edit the Contact
                            ZStack {
                                NavigationLink("", destination: ContactEditView (contact: contact))
                                    .opacity(0)
                                    ContactEditRow(contact: contact)
                            }
                        } else {
                            // Display standard contact Item otherwise
                            NavigationLink(destination: ContactDetailView (contact: contact)) {
                                ContactRow(contact: contact)
                            }
                        }
                    }
                    // Retrive the right contactId from the index of the list
                    // and call the deleteContact function
                    .onDelete { indexSet in
                        // Convertir l'index en identifiant
                        if let index = indexSet.first {
                            let contactToDelete = contactViewModel.filteredContacts[index]
                            contactViewModel.deleteContact(by: contactToDelete.id) { success in
                            }
                        }
                    }

                } // List
                .toolbar {
                    if authViewModel.isSystemAdmin || (authViewModel.isClubAdmin && authViewModel.currentClubId == club.id) {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: ContactEditView (contact: contactViewModel.createNewContact(UUID().uuidString, club.id) ) ) {
                                Image(systemName: "plus")
                            }
                        }
                        
                        ToolbarItem (placement: .navigationBarTrailing) {
                            EditButton().padding(.trailing, 20)
                        }
                    }
                }.environment(\.editMode, $mode) //< -- Here
            }
        } //Vstack
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
