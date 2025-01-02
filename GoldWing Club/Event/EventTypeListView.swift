//
//  EventTypeListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/20/24.
//

import SwiftUI

struct EventTypeListView: View {
    @StateObject private var eventViewModel = EventViewModel()
    
    var club: Club
    
    var body: some View {
            VStack (alignment: .leading ) {
                //  List all the available eventType for a club
                List(eventViewModel.eventTypes, id: \.self) { eventType in
                    //display the Events on top of the adhérents
                    HStack (alignment: .top) {
                        // Role Icon or Dynamic Image
                        Image(systemName: eventViewModel.iconEventType (eventType) ) // Use a system image based on the role
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30) // Set image size
                            .foregroundColor(.blue) // Set image color

                        switch eventType.lowercased()  {
                        case "anniversary":
                            NavigationLink(destination: ContactAnnivListView (clubId: club.id)) {
                                Text("Anniversaire") // Display role in a user-friendly way
                                    .font(.headline)
                            }
                        default:
                            NavigationLink(destination: EventListView(clubId: club.id, eventType: eventType)) {
                                Text(eventType.capitalized) // Display role in a user-friendly way
                                    .font(.headline)
                            }
                        }
                    }
                }
                .onAppear { eventViewModel.loadEventTypes (for: club.id) }
                Spacer()
            }
            .navigationTitle("Evènements")

    }
}

#Preview {
    EventTypeListView(
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

