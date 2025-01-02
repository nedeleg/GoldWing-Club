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
                        Label("Home", systemImage: "house.fill")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.badge.key.fill")
                    }
                InfosListView()
                    .tabItem {
                        Label("News", systemImage: "newspaper.fill")
                    }
                AboutView()
                    .tabItem {
                        Label("Notes", systemImage: "message.fill")
                    }
            }
    }
}

                
/*
        NavigationView {
            List {
                NavigationLink(destination: ContactListView()) {
                    Text("Contacts")
                }
                NavigationLink(destination: ClubListView()) {
                    Text("Clubs")
                }
               NavigationLink(destination: EventListView()) {
                    Text("Events")
                }
                NavigationLink(destination: InfoListView()) {
                    Text("Infos")
                }
            }
            .navigationTitle("Gestion des Données")
        }
    }
 */
        

#Preview {
    MainView()
}
