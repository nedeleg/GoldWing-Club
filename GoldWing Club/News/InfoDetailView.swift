//
//  InfoDetailView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/23/24.
//

import SwiftUI

struct InfoDetailView: View {
    var info: Info
    
    var body: some View {
        List {
            Section(header: Text("Titre / Source")) {
                if !info.title.isEmpty {
                    Link("\(info.title)", destination: (URL(string: info.link) ?? URL(string: "#"))!)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.trailing)
                    
                    // Display the event name
                    HStack {
                        if !info.auteur.isEmpty {
                            Image(systemName: "person.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 15)
                            Text("\(info.auteur)")
                        }
                        Image(systemName: "calendar")
                            .foregroundColor(.yellow)
                            .frame(width: 15)
                        Text(frenchDateHourFormatter.string(from: info.date) )
                    }
                }
            }
            if !info.description.isEmpty {
                Section(header: Text("Résumé")) {
                    Text("\(info.description)")
                }
            }
            
            // Display the news's photo
            if let url = URL(string: info.photo) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .topLeading)
                    
                    //.border(.yellow)
                } placeholder: {
                    Image(systemName: "photo.artframe")
                        .resizable()
                    //.foregroundColor(.gray)
                }
                .cornerRadius(8)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            }
            
            if !info.texte.isEmpty {
                Section(header: Text("Contenu")) {
                    Text("\(info.texte)")
                }
            }
        }
        .navigationTitle(info.title.isEmpty ? "Info." : info.title)
    }
    
}


#Preview {
    InfoDetailView (info: Info (
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

