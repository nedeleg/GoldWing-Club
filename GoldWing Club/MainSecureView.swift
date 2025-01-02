//
//  MainSecureView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/22/24.
//

import SwiftUI

struct MainSecureView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var club: Club
    
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
            ContactListView()
                .tabItem {
                    Label("Contacts", systemImage: "person.circle.fill")
                }
            ClubListView()
                .tabItem {
                    Label("Clubs", systemImage: "person.3.fill")
                }
            MoreView()
                .tabItem {
                    Label("More", systemImage: "newspaper.fill")
                }
        }
    }
}

#Preview {
    MainSecureView(
        club: Club(
            id: "Club10",
            name: "Club Paris",
            region: "Île-de-France",
            email: "voir@email.com",
            members: 35,
            ecusson: "https://example.com/photos/jean.jpg",
            departement: "1,2,3",
            pageFacebook: "http://www.facebook.com",
            photoRegion: "https://example.com/photos/region.jpg"
        )
    )
}
