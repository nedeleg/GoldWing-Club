//
//  ClubDetailView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/19/24.
//

import SwiftUI

struct ClubDetailView: View {
    @StateObject private var clubViewModel = ClubViewModel()
    
    var club: Club
    enum Target: Hashable {
        case events
        case contacts(role: String)
    }
    
    var body: some View {
        VStack{
            VStack (alignment: .leading ) {
                //  List all the available roles for a club
                List(clubViewModel.roles, id: \.self) { role in
                    //display the Events on top of the adhérents
                    HStack (alignment: .top) {
                        // Role Icon or Dynamic Image
                        Image(systemName: clubViewModel.iconForRole(role) ) // Use a system image based on the role
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30) // Set image size
                            .foregroundColor(.blue) // Set image color

                        switch role.lowercased()  {
                        case "events":
                            NavigationLink(destination: EventTypeListView(club: club)) {
                                Text("Evènements") // Display role in a user-friendly way
                                    .font(.headline)
                            }
                        default:
                            NavigationLink(destination: ContactClubListView(club: club, role: role)) {
                                Text(role.capitalized) // Display role in a user-friendly way
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .onAppear { clubViewModel.loadRoleFromContactPerClub (for: club.id) }
            Spacer()
        
            VStack {
                GifImage(clubViewModel.carteForClubId(club.id))
                    .frame(width: 200, height: 200, alignment: .center)
                
                HStack {
                    Image(clubViewModel.ecussonForClubId(club.id)) // Pass club.id to the
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)   // Set image size
                        .clipShape(Circle())            // Optional: Make the image circular
                        .padding(.trailing,5)
                    
                    Text(club.region)
                        .foregroundStyle(.yellow)
                        .bold()
                        .textCase(.uppercase)
                        .font(.title)
                }
            }.opacity(0.5)

        }
        .navigationTitle( club.region )


 }
    
}

#Preview {
    ClubDetailView(
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
