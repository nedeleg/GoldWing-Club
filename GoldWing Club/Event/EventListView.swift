//
//  EventListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/19/24.
//

import SwiftUI

struct EventListView: View {
    @StateObject private var eventViewModel = EventViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var clubId : String     // Club to filter Events
    var eventType: String   // EventType to filter Events
    @State private var errorMessage: String?
    
    @State private var selectedEvent: Event? = nil
    @State var mode: EditMode = .inactive //< -- Here
    
    var body: some View {
        VStack {
            List {
                ForEach (eventViewModel.eventFiltered) { event in
                    if mode == .active {
                        ZStack {
                                NavigationLink("", destination: EventEditView (event: event))
                                .opacity(0)
                                EventEditRow(event: event)
                        }
                    } else {
                        NavigationLink(destination: EventDetailView (event: event)) {
                            EventRow(event: event)
                        }
                    }
                }
                .onDelete { indexSet in
                    // Convertir l'index en identifiant
                    if let index = indexSet.first {
                        let eventToDelete = eventViewModel.eventFiltered [index]
                        eventViewModel.deleteEvent (by: eventToDelete.id)
                    }
                }

            }
            .toolbar {
                // Either SystemAdmin
                // or a Member of the club can create an Event in a club
                if (authViewModel.isSystemAdmin || clubId == authViewModel.currentClubId) {
                    let creator = authViewModel.currentContact?.id
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EventEditView (event: eventViewModel.createNewEvent( UUID().uuidString, eventType, clubId, creator ?? "") ))  {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton().padding(.trailing, 20)
                    }
                }
            }
            .environment(\.editMode, $mode) //< -- Here
            
        }
        .searchable(text: $eventViewModel.searchText, prompt: "Rechercher un évènement")
        .navigationTitle("\(eventType.capitalized)")
        .onAppear { eventViewModel.loadEventsPerClubAndEventType(for: clubId, for: eventType) }
    }
}

#Preview { EventListView (clubId : "Club10" , eventType: "Sorties") }

