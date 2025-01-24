//
//  EventDetailView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/20/24.
//

import SwiftUI
import EventKit // to add en event in Calendar

struct EventDetailView: View {
    @StateObject private var eventViewModel = EventViewModel()
    @StateObject private var contactViewModel = ContactViewModel()

    var event: Event

    @State private var alertMessage = ""
    @State var showingAlert: Bool = false
    
    var body: some View {
        List {
            Section(header: Text("nom")) {
                if !event.name.isEmpty {
                    Text("\(event.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack(alignment: .top) {
                    if !event.eventType.isEmpty {
                        Image("motorcycle") // Pass club.id to the
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.yellow)
                            .frame(width: 25, height: 25)   // Set image size
                            .padding(.trailing,5)
                        
                        Text("\(event.eventType)")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                    }
                }

/*
                HStack(alignment: .top) {
                    if !event.createdBy.isEmpty {
                        Image(systemName: "person.text.rectangle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.purple)
                            .frame(width: 25, height: 25)   // Set image size
                            .padding(.trailing,0)

                        Text("\(event.createdBy)")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                    }
                }
*/
                
                HStack(alignment: .top) {
                    Image(systemName: "calendar.badge.plus")
                        .foregroundColor(.yellow)
                        .frame(width: 25)   // Set image size
                        .padding(.trailing,5)
                        .onTapGesture {
                            self.showingAlert = true
                            eventViewModel.addEventToCalendar(title: event.name, startDate: event.startDate, endDate: event.endDate) { success, error in
                                if success {
                                    alertMessage = "Événement ajouté au calendrier !"
                                } else if let error = error {
                                    alertMessage = "Erreur lors de l'ajout : \(error.localizedDescription)"
                                } else {
                                    alertMessage = "Action refusée. Autorisez l'accès au calendrier dans les réglages."
                                }
                            }
                        }
                    Text(frenchDateHourFormatter.string(from: event.startDate))
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
                .alert(isPresented: $showingAlert, content: {
                            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        })
                

                    HStack(alignment: .top) {
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.yellow)
                        .frame(width: 25)
                        .padding(.trailing,5)
                        
                    Text(frenchDateHourFormatter.string(from: event.endDate) )
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                }
            }
            
            if !event.description.isEmpty {
                Section(header: Text("Résumé")) {
                    Text(event.description)
                }
            }
            
            // Display the news's photo
            if let url = URL(string: event.photo) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .topLeading)
                } placeholder: {
                    Image(systemName: "photo.artframe")
                        .resizable()
                }
                .cornerRadius(8)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            
            if !event.fichierInscription.isEmpty {
                Section(header: Text("Fichier")) {
                    Link("Fichier d'inscription", destination: (URL(string: event.fichierInscription) ?? URL(string: "#"))!)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            if !event.inscriptionForm.isEmpty {
                Section(header: Text("Formulaire")) {
                        
                    Link("Formultaire d'inscription", destination: (URL(string: event.inscriptionForm) ?? URL(string: "#"))!)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.trailing)
                }
            }                
        }
        .navigationTitle("\(event.eventType)")
        //.onAppear {  contactViewModel.loadContact(event.createdBy) }

        
    }
}

#Preview {
    EventDetailView(event: Event(
        id: "1",
        clubId: "Club10",
        eventType : "Sortie",
        name: "Carabalade 2024",
        startDate: Date(),
        endDate: Date().addingTimeInterval (TimeInterval( 60 )),
        createdBy: "Auteur",
        description: "Un sondage a été mis en place afin de vous inscrire pour la Carabalade au profit des orphelins des Sapeurs Pompiers qui aura lieu le 12 Décembre 2024. Le rendez-vous est fixé à 19 heures Place Saint Emilion 75012 PARIS pour un petit repas avant la balade.Comme habituellement un habit festif est souhaité pour cette balade qui traversera Paris, n'oubliez pas un cadeau au profit des orphelins que vous donnerez en fin de parcours. Cette balade n'est pas organisée par notre club.",
        photo: "https://www.parisetoilechapter.fr/images/actualites/659e8521610390.63296758.jpg",
        fichierInscription: "String",
        inscriptionForm: "https://framadate.org/YGECt54cx4FYtUok"
    ) )
}
