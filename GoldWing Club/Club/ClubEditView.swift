//
//  ClubEditView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/19/24.
//

import SwiftUI

struct ClubEditView: View {
    @StateObject private var clubViewModel = ClubViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var club: Club

    @State private var isSaving = false // To show a loading spinner during save
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Informations sur le Club")) {
                    TextField("Name", text: $club.name)
                    TextField("Région", text: $club.region)
                    TextField("E-mail", text: $club.email)
                        .keyboardType(.emailAddress)
                    TextField("Members", value: $club.members,formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Ecusson", text: $club.ecusson)
                        .keyboardType(.URL)
                    TextField("Département", text: $club.departement)
                    TextField("Page Facebook", text: $club.pageFacebook)
                        .keyboardType(.URL)
                    TextField("Photo Region", text: $club.photoRegion)
                        .keyboardType(.URL)
                }
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
                    isSaving = true
                    clubViewModel.saveClub(club) { success in
                        isSaving = false
                        if success {
                            didDismiss() // Close the view on success
                        } else {
                            errorMessage = "Erreur lors de l'enregistrement. Veuillez réessayer."
                        }
                    }
                }) {
                    if isSaving {
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

    }
    
    func didDismiss() {
        dismiss()
        // Handle the dismissing action.
    }

}

#Preview {
    ClubEditView(
        club: Club(
            id: "Club10",
            name: "Club Paris",
            region: "Île-de-France",
            email: "voir@email.com",
            members: 35,
            ecusson: "https://example.com/photos/jean.jpg",
            departement: "1,2,3",
            pageFacebook: "http://www.facebook.com",
            photoRegion: "https://example.com/photos/region.jpg"
        )
    )
}
