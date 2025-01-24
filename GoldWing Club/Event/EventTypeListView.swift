//
//  EventTypeListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/20/24.
//

import SwiftUI

struct EventTypeListView: View {
    @StateObject private var eventViewModel = EventViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var club: Club
    @State var mode: EditMode = .inactive //< -- Here
    
    var body: some View {
        VStack (alignment: .leading ) {
            List {
                //  List all the available eventType for a club
                ForEach (eventViewModel.eventTypes, id: \.self) { eventType in
                    
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
                                Text("Anniversaire à venir") // Display role in a user-friendly way
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
            }
            .toolbar {
                // Either SystemAdmin
                // or a Member of the club can create an Event in a club
                if (authViewModel.isSystemAdmin || club.id == authViewModel.currentClubId) {
                    let creator = authViewModel.currentContact?.id
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink (destination: EventEditView (event: eventViewModel.createNewEvent(
                            UUID().uuidString, "Assemblée", club.id, creator ?? "" )))  {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .environment(\.editMode, $mode) //< -- Here
        .onAppear { eventViewModel.loadEventTypes (for: club.id) }
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

