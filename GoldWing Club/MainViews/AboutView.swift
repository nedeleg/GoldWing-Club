//
//  About.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/22/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // App Logo or Image
                Image("GoldWing2020logo") // Replace with your asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                
                // App Title
                Text(" GoldWing App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                // Description
                
                Text("Conçue pour les membres, partenaires et passionnés du GoldWing Club, cette application est votre compagnon idéal pour rester connecté avec votre club, les clubs régionaux, découvrir les événements à venir et échanger avec d'autres membres de la communauté.\r\rNotre objectif : rapprocher les passionnés et offrir toutes les informations essentielles, accessibles du bout des doigts.\r\rRejoignez-nous et vivez pleinement l'esprit GoldWing !")
                    .font(.body)
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Text("Le Druide ")
                        .font(.footnote)
                        .padding(.leading,10)
                    Spacer()
                    // Version Information
                    Text("App Version: 1.0.0")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.trailing,10)
                }.padding(.top,20)
                
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
