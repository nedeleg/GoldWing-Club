//
//  ContactListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

struct ContactListViewSave: View {
    @StateObject private var viewModel = ContactViewModel()
    
    @State private var selectedContact: Contact? = nil
    @State var mode: EditMode = .inactive //< -- Here
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Chargement...")
            } else {
                List {
                    ForEach(viewModel.filteredContacts) { contact in
                        if mode == .active {
                            HStack {
                                ContactRow(contact: contact)
                                Spacer()
                                Button(action: {
                                    // Ensure selectedContact is set first
                                    selectedContact = contact
                                }) {
                                    Image(systemName: "pencil") // Edit icon
                                }
                            }
                        } else {
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRow(contact: contact)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteContact)
                }
                .sheet(item: $selectedContact) {contact in
                    let _ = print ("selectedContact : \(String(describing: contact))")
                    ContactEditView(contact: contact)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: viewModel.addContact) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text(mode == .active ? "A" : "B")
                    }
                }.environment(\.editMode, $mode) //< -- Here
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Rechercher un contact")
        .navigationTitle("Contacts")
        .onAppear {
            viewModel.loadContacts()
        }
    }
}
/*
#Preview {
    ContactListView()
}
*/
