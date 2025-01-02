//
//  ClubEditRow.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/28/24.
//

import SwiftUI

struct ClubEditRow: View {
    @StateObject private var clubViewModel = ClubViewModel()
    
    var club: Club
    
    var body: some View {

        HStack {
            HStack {
                // Club Image from Asset Library
                Image(clubViewModel.ecussonForClubId(club.id)) // Pass club.id to the
                 .resizable()
                 .scaledToFit()
                 .frame(width: 60, height: 60)   // Set image size
                 .clipShape(Circle())            // Optional: Make the image circular
                 .padding(.trailing,5)

                VStack(alignment: .leading) {
                    Text(club.name)
                        .font(.headline)
                    Text(club.region)
                        .font(.subheadline)
                    Text("Members: \(club.members)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Button(action: {
                // Ensure selectedContact is set first
                // selectedClub = club
            }) {
                Image(systemName: "pencil").foregroundColor(.red)  // Edit icon
            }
            //.buttonStyle(BorderlessButtonStyle()) // Ensure the button doesn't interfere with row taps
        }
        
    }
}

#Preview {
    ClubEditRow(
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
