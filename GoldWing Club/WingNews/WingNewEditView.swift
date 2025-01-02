//
//  WingNewEditView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct WingNewEditView: View {
    @StateObject private var wingNewiewModel = WingNewViewModel()
    @Environment(\.dismiss) var dismiss

    @State var wingNew: WingNew

    @State private var errorMessage: String? = nil


    var body: some View {
        Form {
            Section(header: Text("Informations principales")) {
                TextField("Titre", text: $wingNew.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("url_source", text: $wingNew.url_source)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("photo", text: $wingNew.photo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker("Date", selection: $wingNew.date,  displayedComponents: .date)
            }
            
        }
        .navigationTitle("Modifier le Katrapla")
        
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
                wingNewiewModel.saveWingNew (wingNew) { success in
                    if success {
                        didDismiss() // Close the view on success
                    } else {
                        errorMessage = "Erreur lors de l'enregistrement. Veuillez réessayer."
                    }
                }
            }) {
                if wingNewiewModel.isWingNewLoading {
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
        
        
    }
    
    func didDismiss() {
        dismiss()
        // Handle the dismissing action.
    }}

#Preview {
    WingNewEditView (wingNew: WingNew (
        id: "0",
        title: "Gold News Avril 1987",
        url_source : "https://www.calameo.com/books/004526907a1cd0f6663ff",
        photo : "https://i.calameoassets.com/201229194556-a8c542e90e42d34f8f840d3b20f6b535/large.jpg",
        date: Date()
        ))

}
