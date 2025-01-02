//
//  EventDetailView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/20/24.
//

import SwiftUI

struct EventDetailView: View {
    @StateObject private var eventViewModel = EventViewModel()

    var event: Event

    var body: some View {
        ScrollView {
            
            VStack (alignment: .leading) {
                HStack(alignment: .top) {
                    Text("\(event.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.trailing)
                }
                Divider()
                HStack(alignment: .top) {
                    
                    Image("motorcycle") // Pass club.id to the
                     .resizable()
                     .scaledToFit()
                     .foregroundColor(.yellow)
                     .frame(width: 25, height: 25)   // Set image size
                     .padding(.trailing,0)
                     .padding(.leading,10)

                    if !event.eventType.isEmpty {
                        Text("\(event.eventType)")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)

                    }
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.yellow)
                        .frame(width: 15)
                    Text(dateFormatter.string(from: event.date) )
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                }
                Divider()
                if !event.description.isEmpty {
                    HStack(alignment: .top) {
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
                Divider()
                // Display the contact's photo
                if let url = URL(string: event.photo) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(alignment: .topLeading)
                        //.border(.yellow)
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                        //.foregroundColor(.gray)
                    }
                    .cornerRadius(8)
                }
                Divider()
                if !event.fichierInscription.isEmpty {
                    HStack(alignment: .top) {
                        Link("Fichier d'inscription", destination: (URL(string: event.fichierInscription) ?? URL(string: "#"))!)
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.trailing)

                    }
                }

                Divider()
                if !event.inscriptionForm.isEmpty {
                    HStack(alignment: .top) {
                        Link("Formultaire dinscription", destination: (URL(string: event.inscriptionForm) ?? URL(string: "#"))!)
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.trailing)

                    }
                }

                Spacer()
                
                
            }
            .padding(20)

            
            .navigationTitle("\(event.eventType)")
            
            
        }
    }
}

#Preview {
    EventDetailView(event: Event(
        id: "1",
        clubId: "Club10",
        eventType : "Sortie",
        name: "Carabalade 2024",
        date: Date(),
        description: "Un sondage a été mis en place afin de vous inscrire pour la Carabalade au profit des orphelins des Sapeurs Pompiers qui aura lieu le 12 Décembre 2024. Le rendez-vous est fixé à 19 heures Place Saint Emilion 75012 PARIS pour un petit repas avant la balade.Comme habituellement un habit festif est souhaité pour cette balade qui traversera Paris, n'oubliez pas un cadeau au profit des orphelins que vous donnerez en fin de parcours. Cette balade n'est pas organisée par notre club.",
        photo: "https://www.parisetoilechapter.fr/images/actualites/659e8521610390.63296758.jpg",
        fichierInscription: "String",
        inscriptionForm: "https://framadate.org/YGECt54cx4FYtUok"
    ) )
}
