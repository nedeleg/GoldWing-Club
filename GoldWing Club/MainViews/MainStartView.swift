//
//  MainStartView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 1/16/25.
//

import SwiftUI

struct MainStartView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.badge.key.fill")
                }
            AboutView()
                .tabItem {
                    Label("Notes", systemImage: "message.fill")
                }
        }
    }
}

#Preview {
    MainStartView()
}
