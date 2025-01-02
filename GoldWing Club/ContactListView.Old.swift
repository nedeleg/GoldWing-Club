//
//  ContactListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

struct ContactListViewOld: View {

    @StateObject private var viewModel = ContactViewModel()
    
    @State private var isEditMode: Bool = false
    @State private var selectedContact: Contact? = nil
    @State private var isShowingDetailView: Bool = false
    @State var mode: EditMode = .inactive //< -- Here

    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Chargement...")
            } else {
                List {
                    ForEach(viewModel.filteredContacts) { contact in
                        HStack {
                            ContactRow(contact: contact)
                            if mode == .active {
                                Spacer()
                                Button(action: {
                                    // Ensure selectedContact is set first
                                    selectedContact = contact
                                    isEditMode = true
                                    isShowingDetailView = true
                                }) {
                                    Image(systemName: "pencil") // Edit icon
                                }
                            }
                        }
                        
                        
/*
                        Button {
                            selectedContact = contact
                            isEditMode = true // Enable edit mode
                            isShowingDetailView = true
                        } label: { ContactRow(contact: contact) }


                       HStack {
                            ContactRow(contact: contact)
                            Spacer()
                            Button(action: {
                                // Ensure selectedContact is set first
                                selectedContact = contact
                                isEditMode = true
                                isShowingDetailView = true
                            }) {
                                Image(systemName: "pencil") // Edit icon
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Ensure the button doesn't interfere with row taps
                            .sheet(isPresented: $isShowingDetailView) {
                                let _ = print ("selectedContact : \(String(describing: contact))")
                                ContactDetailView(contact: contact, isEditMode: $isEditMode)
                                
                                .navigationBarItems(trailing: ContactListView())
                                Button("Done") {
                                    isShowingDetailView = false
                                    print ("Closed !")
                                }

                            }
                        }
*/
                    }
                    .onDelete(perform: viewModel.deleteContact)
/*
                    .sheet(isPresented: $isShowingDetailView) {
                        let _ = print ("selectedContact : \(String(describing: selectedContact))")
                        
                        ContactListView()
                        let _ = print ("Test ")
                        if let contact = selectedContact {
                            let _ = print ("Contact : \(contact) ")
                            ContactDetailView(contact: contact, isEditMode: $isEditMode)
                        }
                    }
*/


                }
                
                .sheet(item: $selectedContact) {contact in
                    let _ = print ("selectedContact : \(String(describing: contact))")
                    ContactDetailView(contact: contact)

                    Button("Done") {
                        isShowingDetailView = false
                        print ("Closed !")
                    }

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

/*
                List {
                    ForEach(viewModel.filteredContacts) { contact in

                        NavigationLink {
                            VStack(alignment: .leading) {
                                Text(contact.fullName)
                            }

                        } label: {
                            ContactRow(contact: contact)
                        }
                    }
                    .onDelete(perform: viewModel.deleteContact )

                }
                .sheet(isPresented: $isShowingDetailView) {
                    if let contact = selectedContact {
                        ContactDetailView(contact: contact, isEditMode: $isEditMode)
                    }
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
                }
            }
        }
        .onAppear {
            viewModel.loadContacts()
        }
        .navigationTitle("Contacts")
        .searchable(text: $viewModel.searchText, prompt: "Rechercher un contact")
    }
*/
}
/*
#Preview {
    ContactListView()
}
*/
