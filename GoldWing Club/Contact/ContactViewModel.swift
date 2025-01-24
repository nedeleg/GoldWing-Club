//
//  ContactViewModel.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import Foundation

import SwiftUI
import FirebaseStorage

class ContactViewModel: ObservableObject {

    @Published var contacts: [Contact] = []
    @Published var isLoading = false
    @Published var isContactSaving = false
    @Published var isContactDeleting = false
    @Published var isAddingContact = false  // Check if we're asking to add a new contact

    @Published var clubs: [Club] = [] // to populate the Club Picker in ContactEditView

    @Published var searchText: String = ""
    @State private var errorMessage: String? = nil
    
    @Published var contact: Contact? = nil

    @State var refreshView = false
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contact.firstName.localizedStandardContains(searchText) ||
                contact.lastName.localizedStandardContains(searchText)
                
            }
        }
    }
        
    func loadAllContacts() {
        isLoading = true
        DataService.shared.fetchAllContacts { contacts in
            DispatchQueue.main.async {
                self.contacts = contacts
                self.isLoading = false
            }
        }
    }

    func loadContact(_ id: String) {
        isLoading = true
        DataService.shared.fetchContact(withUID: id) { fetchedContact, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.contact = fetchedContact
                }
                self.isLoading = false
            }
        }
    }
    
    
    
    func loadContactsForClubAndRole (for clubId: String, for role: String ) {
        isLoading = true
        DataService.shared.fetchContactsForClubAndRole (withCLUBID: clubId, withROLE: role ) { fetchedContacts, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.contacts = fetchedContacts ?? []
            }
            self.isLoading = false
        }
    }

    func loadMonthAnniversaries  (for clubId: String, for date: Date) {
        isLoading = true
        DataService.shared.fetchContactsForAnniversaries (withCLUBID: clubId, withDATE: date)  { fetchedContacts, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.contacts = fetchedContacts ?? []
            }
            self.isLoading = false
        }
    }

    
    // function to prepare an empty content to send to the EditForm
    func createNewContact(_ id: String, _ clubId: String) -> Contact {
        let newContact = Contact(
            id: id,
            uid: "",
            firstName: "",
            lastName: "",
            nickName: "",
            clubId: clubId,
            role: "Adhérent",
            userStatus: "UnApproved",
            userProfile: "User",
            title: "",
            gender: "Homme",
            birthday: Date(),
            cellPhone: "",
            homePhone: "",
            workPhone: "",
            email: "",
            address: "",
            city: "",
            postalCode: "",
            country: "France",
            notes: "",  
            photo: "" )
        return newContact
    }
    

    func saveContact(_ contact: Contact, _ profileImage: UIImage?,  completion: @escaping (Contact?, Bool) -> Void) {
        isContactSaving = true

        if profileImage != nil {
            var contactToSave = contact
            
            DataService.shared.uploadProfileImage (contactToSave, profileImage) { result in
                switch result {
                case .success(let url):
                    contactToSave.photo = url
                    print ("Photo saved")
                    // Save the contact to Firebase or local database

                    DataService.shared.saveContact(contactToSave) { success in
                        if success {
                            if let index = self.contacts.firstIndex(where: { $0.id == contactToSave.id }) {
                                self.contacts[index] = contactToSave
                                print("Contact enregistré avec succès.")
                            }
                            completion(contactToSave,true)
                            self.isContactSaving = false
                        } else {
                            print("Erreur lors de l'enregistrement")
                            completion(contactToSave,false)
                            self.isContactSaving = false
                        }
                    }

                case .failure(let error):
                    print ("Photo not saved")
                    self.errorMessage = error.localizedDescription
                }
            }
        } else {
            // The profileImage has not been replaced
            DataService.shared.saveContact(contact) { success in
                if success {
                    if let index = self.contacts.firstIndex(where: { $0.id == contact.id }) {
                        self.contacts[index] = contact
                        print("Contact enregistré avec succès.")
                    }
                    completion(contact,true)
                    self.isContactSaving = false
                } else {
                    print("Erreur lors de l'enregistrement")
                    completion(contact,false)
                    self.isContactSaving = false
                }
            }
        }

    }
/*
    func deleteContact(by ContactId: String) {
        self.isContactDeleting = true
        DataService.shared.deleteProfileImage (withId: ContactId) { success in
            if success {
                print ("Photo for \(ContactId) deleted")
            }
        }
        DataService.shared.deleteContact (withId: ContactId) { success in
            if success {
                if let index = self.contacts.firstIndex(where: { $0.id == ContactId }) {
                    self.contacts.remove(at: index)
                    print ("\(ContactId) deleted")
                }
            }
            self.isContactDeleting = false
        }
    }
*/
    func deleteContact(by contactId: String, completion: @escaping (Bool) -> Void ) {
        self.isContactDeleting = true
        
        let dispatchGroup = DispatchGroup()
        
        // Attempt to delete the profile image
        dispatchGroup.enter()
        DataService.shared.deleteProfileImage(withId: contactId) { success in
            if success {
                print("Photo for \(contactId) deleted")
                dispatchGroup.leave() // Ensure we continue regardless of success or failure
            } else {
                print("No photo to delete or failed to delete photo for \(contactId)")
                dispatchGroup.leave() // Ensure we continue regardless of success or failure
            }
        }
        // Once the profile image deletion is handled, proceed to delete the contact
        dispatchGroup.notify(queue: .main) {
            DataService.shared.deleteContact(withId: contactId) { success in
                if success {
                    if let index = self.contacts.firstIndex(where: { $0.id == contactId }) {
                        self.contacts.remove(at: index)
                        print("\(contactId) deleted")
                    }
                    completion(true)
                } else {
                    print("Failed to delete contact \(contactId)")
                    completion(false)
                }
                self.isContactDeleting = false
            }
        }
    }
    
    func loadAllClubs() {
        isLoading = true
        DataService.shared.fetchAllClubs { fetchedClubs, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.clubs = fetchedClubs ?? []
            }
        }
        isLoading = false
    }
    
}
