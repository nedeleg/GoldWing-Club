//
//  EventEditView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/25/24.
//

import SwiftUI

struct EventEditView: View {
    @StateObject private var eventViewModel = EventViewModel()
    @Environment(\.dismiss) var dismiss

    @State var event: Event // Binding pour modifier un événement existant
    @State private var showPhotoPicker = false // Pour gérer l'importation d'une photo

    @State private var isSaving = false // To show a loading spinner during save
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Informations principales")) {
                    TextField("Nom de l'événement", text: $event.name)
                    
                    Picker("Type d'événement", selection: $event.eventType) {
                        ForEach(eventViewModel.eventTypes, id: \.self) { eventType in
                            Text(eventType).tag(eventType)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    DatePicker("Date", selection: $event.startDate, displayedComponents: [.date, .hourAndMinute])

                    DatePicker("Fin", selection: $event.endDate, displayedComponents: [.date, .hourAndMinute])
                    // DatePickerFin
                }
                
                Section(header: Text("Détails")) {
                    TextField("Description", text: $event.description)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .frame(height: 100)
                        .foregroundStyle(Color.clear)
                        .overlay {
                            TextEditor(text: $event.description)
                        }
                }
                    
                Section(header: Text("Photo")) {
                    TextField("Lien photo", text: $event.photo)
                }

/*
                    Button(action: {
                        showPhotoPicker.toggle()
                    }) {
                        HStack {
                            Text("Choisir une photo")
                            Spacer()
                            if !event.photo.isEmpty {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }

 */
                Section(header: Text("Inscriptions")) {
                    TextField("Fichier d'inscription", text: $event.fichierInscription)
                    TextField("Formulaire d'inscription", text: $event.inscriptionForm)
                }
            }
            .navigationTitle("Modifier l'événement")
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
                    isSaving = true
                    eventViewModel.saveEvent(event) { success in
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
            
            
            
        }
        .onAppear {eventViewModel.loadAllEventTypes() }
    }
    



    func didDismiss() {
        dismiss()
        // Handle the dismissing action.
    }

    
}

#Preview {
    EventDetailView(event: Event(
        id: "1",
        clubId: "Club10",
        eventType : "Sortie",
        name: "Carabalade 2024",
        startDate: Date(),
        endDate: Date().addingTimeInterval (TimeInterval( 60 ) ),
        createdBy: "Auteur",
        description: "Un sondage a été mis en place afin de vous inscrire pour la Carabalade au profit des orphelins des Sapeurs Pompiers qui aura lieu le 12 Décembre 2024. Le rendez-vous est fixé à 19 heures Place Saint Emilion 75012 PARIS pour un petit repas avant la balade.Comme habituellement un habit festif est souhaité pour cette balade qui traversera Paris, n'oubliez pas un cadeau au profit des orphelins que vous donnerez en fin de parcours. Cette balade n'est pas organisée par notre club.",
        photo: "https://www.parisetoilechapter.fr/images/actualites/659e8521610390.63296758.jpg",
        fichierInscription: "String",
        inscriptionForm: "https://framadate.org/YGECt54cx4FYtUok"
    ) )
}
