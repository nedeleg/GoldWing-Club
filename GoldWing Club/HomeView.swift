//
//  HomeView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/22/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        let _ = print("Load HomeView")
        
        NavigationStack {
            VStack {
                Image(uiImage: #imageLiteral(resourceName: "goldwing-club-france_app.png"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
                
                Text("Fédération des GoldWing Club de France")
                    .foregroundStyle(.yellow)
                    .bold()
                    .textCase(.uppercase)
                    .padding()
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
