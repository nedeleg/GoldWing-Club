//
//  ContactEditView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

struct ContactEditView: View {
    @StateObject private var contactViewModel = ContactViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showImagePicker = false
    
    @State var contact: Contact
    
    @State private var isSaving = false // To show a loading spinner during save
    //@State private var onSave: (Contact, @escaping (Bool) -> Void) -> Void // Closure for saving the contact with a completion

    @State private var errorMessage: String? = nil

    @State private var profileImage: UIImage? = nil // Profile image locally loaded
 
    //@Binding var mode: EditMode
    //@Binding var isEditMode: Bool
    
    
    var body: some View {
        VStack  {
            Form {
                Section(header: Text("Informations personnelles")) {
                    TextField("Prénom", text: $contact.firstName)
                    TextField("Nom", text: $contact.lastName)

                    TextField("Pseudo", text: $contact.nickName)
                    TextField("Titre", text: $contact.title)
                    
                    Picker("Genre", selection: $contact.gender) {
                        Text("Homme").tag("Homme")
                        Text("Femme").tag("Femme")
                        Text("Autre").tag("Autre")
                    }
                    DatePicker("Né(e) le ", selection: $contact.birthday,  displayedComponents: .date) // hourAndMinute
                    //Text("Selected Date: \(contact.birthday, formatter: dateFormatter)")
                }
                    
                Section(header: Text("Administration")) {

                    // Only SystemAdmin
                    // Or User part of a ClubAdmin
                    if authViewModel.isSystemAdmin || (authViewModel.isClubAdmin && authViewModel.currentClubId == contact.clubId) {
                        TextField("Adhérent No", text: $contact.uid)
                        Picker("Role", selection: $contact.role) {
                            Text("Bureau").tag("Bureau")
                            Text("Admin").tag("Admin")
                            Text("Partenaire").tag("Partenaire")
                            Text("Adhérent").tag("Adhérent")
                            Text("Sympathisant").tag("Sympathisant")
                            Text("Autre").tag("Autre")
                        }
                        Picker("Status", selection: $contact.userStatus) {
                            Text("Approved").tag("Approved")
                            Text("UnApproved").tag("UnApproved")
                        }
                    } else {
                        HStack {
                            Text ("Adhérent")
                            Spacer()
                            Text (contact.uid)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Only SystemAdmin
                    // or User itself before beeing Approved can update his club
                    if authViewModel.isSystemAdmin || ((contact.id == authViewModel.currentContact?.id) && contact.userStatus == "UnApproved") {
                        Picker("Club", selection: $contact.clubId) {
                            ForEach(contactViewModel.clubs) { club in
                                Text(club.region)
                                    .tag(club.id)
                            }
                        }
                    } else {
                        HStack {
                            Text ("Club")
                            Spacer()
                            let clubRegion = contactViewModel.clubs.first { $0.id == contact.clubId }?.region
                            Text (clubRegion ?? "")
                                .foregroundStyle(.primary)
                                .foregroundColor(.orange)
                        }
                    }

                }
                
                Section(header: Text("Coordonnées")) {
                    TextField("Tél. Mobile", text: $contact.cellPhone)
                        .keyboardType(.phonePad)
                    TextField("Tél. Domicile", text: $contact.homePhone)
                        .keyboardType(.phonePad)
                    TextField("Tél. Bureau", text: $contact.workPhone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $contact.email)
                        .keyboardType(.emailAddress)
                    TextField("Adresse", text: $contact.address)
                    TextField("Ville", text: $contact.city)
                    TextField("Code postal", text: $contact.postalCode)
                    TextField("Pays", text: $contact.country)
                }

                Section(header: Text("Notes")) {
                    TextField("Notes", text: $contact.notes)
                        .multilineTextAlignment(.leading)
                        .lineLimit(6)
                        .frame(height: 150)
                        .foregroundStyle(Color.clear)
                        .overlay {
                            TextEditor(text: $contact.notes)
                        }
                }
                

                Section(header: Text("Photo")) {
                    HStack (alignment: .center, spacing: 10 ) {
                        if profileImage != nil  {
                            Image(uiImage: profileImage!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .clipShape(Circle())
                        } else if let url = URL(string: contact.photo) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                            }
                        } else {
                            Text("Aucune image sélectionnée")
                        }
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Changer la photo")
                        }
                    }

/*
                    Button(action: {
                        contactViewModel.selectProfileImage()
                    }) {
                        Text("Changer la photo")
                    }
*/
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $profileImage)
            }
            
            HStack {
                //Cancel Button
                Button(action: didDismiss ) {
                    Text("Annuler")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                // Save Button
                Button(action: {
                    // Save the contact to Firebase or local database
                    contactViewModel.saveContact(contact, profileImage) { savedContact, success  in
                        if success {
                            if contact.id == authViewModel.currentContact?.id {
                                authViewModel.currentContact = savedContact
                            }
                            didDismiss() // Close the view on success
                        } else {
                            errorMessage = "Erreur lors de l'enregistrement. Veuillez réessayer."
                        }
                    }
                }) {
                    if contactViewModel.isContactSaving {
                        ProgressView()
                    } else {
                        Text("Enregistrer")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()

            }

            
            Spacer()
        }
        .navigationTitle("\(contact.firstName) \(contact.lastName)")
        .onAppear {contactViewModel.loadAllClubs() }

}

func didDismiss() {
    dismiss()
    // Handle the dismissing action.
}
}

struct ContactEditView_Previews: PreviewProvider {
    static var previews: some View {
        ContactEditView(contact: Contact(
            id: "1",
            uid : "1",
            firstName: "Jean",
            lastName: "Dupont",
            nickName: "JD",
            clubId: "Club10",
            role: "Bureau",
            userStatus: "Approved",
            userProfile: "User",
            title: "Président",
            gender: "M",
            birthday: Date(),
            cellPhone: "0612345678",
            homePhone: "0612345678",
            workPhone: "0612345678",
            email: "jean.dupont@example.com",
            address: "123 Rue Lafayette",
            city: "Paris",
            postalCode: "75011",
            country: "France",
            notes: "President of the club",
            photo: "https://via.placeholder.com/80"
        ) )
        .previewLayout(.sizeThatFits)
        
    }
}

/*
#Preview {
    ContactEditView()
}
*/
