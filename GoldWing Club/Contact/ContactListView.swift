//
//  ContactListViewNew.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

struct ContactListView: View {
    @StateObject private var contactViewModel = ContactViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var selectedContact: Contact? = nil
    @State var mode: EditMode = .inactive //< -- Here
    @State var isPresented: Bool = false //< -- Here
    
    var body: some View {
        
        NavigationView {
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
                                // list all the contact Item otherwise
                                NavigationLink(destination: ContactDetailView (contact: contact)) {
                                    ContactRow(contact: contact)
                                }
                            }
                        }
                        // Retrive the richt contactId from the index of the list
                        // and call the deleteContact function
                        .onDelete { indexSet in
                            // Convertir l'index en identifiant
                            if let index = indexSet.first {
                                let contactToDelete = contactViewModel.filteredContacts[index]
                                contactViewModel.deleteContact(by: contactToDelete.id) { success in
                                }

                            }
                        }
                    }
                    // We didn't used it because
                    // 1.- it make it hard to refresh the Contact in the list
                    // 2.- The windows is not as easy as a navigation view
                    //.sheet(item: $selectedContact) {contact in
                    //    ContactEditView (contact: contact)
                    //}
                    .toolbar {
                        if authViewModel.isSystemAdmin {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                    NavigationLink(destination: ContactEditView (contact: contactViewModel.createNewContact(UUID().uuidString, "FedeFR") ) ) {
                                        Image(systemName: "plus")
                                }
                            }

                            ToolbarItem (placement: .navigationBarTrailing) {
                                EditButton().padding(.trailing, 20)
                            }
                        }
                        
                        // ToolbarItem {
                        //    Button(action: ContactEditView (contact: contactViewModel.createNewContact(UUID().uuidString) ) ) {
                        //        Label("Add Item", systemImage: "plus")
                        //    }
                        //}
                        // ToolbarItem(placement: .navigationBarTrailing) {
                        //    Text(mode == .active ? "A" : "B") }

                    }.environment(\.editMode, $mode) //< -- Here
                }
            }
            .searchable(text: $contactViewModel.searchText, prompt: "Rechercher un contact")
            .navigationTitle("Contacts")
            .onAppear {  contactViewModel.loadAllContacts() }
            .onDisappear() {
                print("ContactListView Disappears.") }

        }
    }
}

#Preview {
    ContactListView()
}

