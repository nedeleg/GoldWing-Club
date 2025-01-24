//
//  MainView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.badge.key.fill")
                }
            MoreView()
                .tabItem {
                    Label("Infos", systemImage: "newspaper.fill")
                }
            AboutView()
                .tabItem {
                    Label("Notes", systemImage: "message.fill")
                }
        }
    }
}


#Preview {
    MainView()
}
