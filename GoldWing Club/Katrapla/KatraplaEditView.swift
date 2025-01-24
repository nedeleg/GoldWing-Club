//
//  KatraplaEditView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct KatraplaEditView: View {
    @StateObject private var katraplaViewModel = KatraplaViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var katrapla: Katrapla
    
    @State private var errorMessage: String? = nil
    
    
    var body: some View {
        Form {
            Section(header: Text("Numéro Katrapla")) {
                TextField("Numéro", text: $katrapla.numero)
                TextField("Titre", text: $katrapla.title)
                TextField("url_source", text: $katrapla.url_source)
                TextField("photo", text: $katrapla.photo)
                DatePicker("Date", selection: $katrapla.date,  displayedComponents: .date)
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
                katraplaViewModel.saveKatrapla (katrapla) { success in
                    if success {
                        didDismiss() // Close the view on success
                    } else {
                        errorMessage = "Erreur lors de l'enregistrement. Veuillez réessayer."
                    }
                }
            }) {
                if katraplaViewModel.isKatraplaLoading {
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
    }
    
}

#Preview {
    KatraplaEditView (katrapla: Katrapla (
        id: "0",
        numero : "1",
        title: "Katrapla 001 - 1981",
        url_source : "https://www.calameo.com/books/00452690731446eb43436",
        photo : "https://i.calameoassets.com/170504202135-b1a2708eada340fbd36ecab29923a2c8/large.jpg",
        date: Date()
    ))
}
