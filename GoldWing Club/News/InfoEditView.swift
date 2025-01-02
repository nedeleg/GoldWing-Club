//
//  InfoeditView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/23/24.
//

import SwiftUI

struct InfoEditView: View {
    @StateObject private var infoViewModel = InfoViewModel()
    @Environment(\.dismiss) var dismiss

    @State var info: Info
    
    @State private var isInfoSaving = false // To show a loading spinner during save
    @State private var errorMessage: String? = nil
    @State private var showPhotoPicker = false // Pour gérer l'importation d'une photo
    
    var body: some View {
        
        Form {
            Section(header: Text("Informations principales")) {
                TextField("Titre", text: $info.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("auteur", text: $info.auteur)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker("Date", selection: $info.date,  displayedComponents: .date)
                
                TextField("Texte", text: $info.description)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                    .frame(height: 100)
                    .foregroundStyle(Color.clear)
                    .overlay {
                        TextEditor(text: $info.description)
                    }

            }
            
            Section(header: Text("Contenu")) {
                
                TextField("photo", text: $info.photo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Texte", text: $info.texte)
                    .multilineTextAlignment(.leading)
                    .lineLimit(6)
                    .frame(height: 150)
                    .foregroundStyle(Color.clear)
                    .overlay {
                        TextEditor(text: $info.texte)
                    }


                TextField("Link", text: $info.link)
                
            }
            
        }
        .navigationTitle("Modifier l'info")
        .sheet(isPresented: $showPhotoPicker) {
            // Intégrer un sélecteur de photo si nécessaire
            Text("Sélecteur de photo non implémenté")
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
                isInfoSaving = true
                infoViewModel.saveInfo (info) { success in
                    isInfoSaving = false
                    if success {
                        didDismiss() // Close the view on success
                    } else {
                        errorMessage = "Erreur lors de l'enregistrement. Veuillez réessayer."
                    }
                }
            }) {
                if isInfoSaving {
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
    InfoEditView (info: Info (
        id: "1",
        title: "Une rivale venue de chine",
        auteur : "Olivier Cottrel",
        date: Date(),
        description: "Géant de l’industrie automobile chinoise, le groupe Great Wall Motors s’apprête à se lancer sur le marché de la moto avec une gamme de modèles équipés d’un moteur huit-cylindres. Parmi ces nouveautés, on devrait notamment retrouver une routière façon Honda Gold Wing.",
        photo: "https://images.caradisiac.com/logos/2/3/8/8/282388/S7-une-rivale-venue-de-chine-pour-la-honda-gold-wing-208335.jpg",
        texte: "Poids lourd de l’industrie automobile chinoise, le groupe Great Wall Motors (GWM) entend bien se diversifier. Si cela passe par l’arrivée sur le marché automobile européen, le géant chinois compte également se faire une place dans l’industrie du deux-roues via sa marque Souo Motorcycle. \n Une arrivée qui devrait se faire en force, avec une gamme articulée autour d’un moteur huit-cylindres à plat d’environ 2 000 cm3. \nÀ ce jour, au moins deux modèles sont attendus très bientôt, un power-cruiser façon Honda Valkyrie Rune, et une version habillée reprenant cette fois le style de la mythique routière Honda Gold Wing. \nSelon des croquis issus des dépôts de brevets concernant les modèles, on devrait aussi retrouver sur ces motos un système semi-automatique à double embrayage inspiré par le DCT Honda (Dual Clutch Transmission) et un dispositif de refroidissement également identique à ce que l’on trouve sur la Gold Wing. \nUne vidéo du milliardaire Wei Jianjuan, propriétaire de GWM, publiée sur les réseaux sociaux, déambulant devant une moto partiellement bâchée accrédite l’imminence de la présentation.",
        link: "https://www.caradisiac.com/une-rivale-venue-de-chine-pour-la-honda-gold-wing-208335.htm"
    ))
}

