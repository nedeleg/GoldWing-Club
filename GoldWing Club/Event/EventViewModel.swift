//
//  EventViewModel.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/20/24.
//

import Foundation

import SwiftUI
import EventKit // To create event in local Calendar



class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var isEventsLoading = false
    @Published var eventTypes: [String] = []  // EventTypes from a Event
    
    @Published var searchText: String = ""
    @State private var errorMessage: String? = nil
    
    var eventFiltered: [Event] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { event in
                event.name.localizedStandardContains(searchText) ||
                event.description.localizedStandardContains(searchText)
            }
        }
    }

    func loadAllEvents() {
        print ("isInfoLoading Start: \(self.isEventsLoading)")
        self.isEventsLoading = true
        DataService.shared.fetchAllEvents { fetchedEvents, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.events = fetchedEvents ?? []

                self.events.sort(by: { element1, element2 in
                    let comparisonResult = element1.startDate.compare(element2.startDate)
                    return comparisonResult == .orderedDescending
                })
            }
            self.isEventsLoading = false
        }
    }

    func loadEventsPerClubAndEventType (for clubId: String, for eventType: String ) {
        DataService.shared.fetchEventsPerClubAndEventType (withCLUBID: clubId, withEVENT: eventType ) { fetchedEvents, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.events = fetchedEvents ?? []

                self.events.sort(by: { element1, element2 in
                    let comparisonResult = element1.startDate.compare(element2.startDate)
                    return comparisonResult == .orderedDescending
                })
            }
        }
    }

    
    func deleteEvent(by eventId: String) {
        DataService.shared.deleteEvent (withId: eventId) { success in
            if success {
                if let index = self.events.firstIndex(where: { $0.id == eventId }) {
                    self.events.remove(at: index)
                    print ("\(eventId) deleted")
                }
            }
        }
    }
/*
    @State var newEvent = Event (
        id: UUID().uuidString,
        clubId: "",
        eventType: "",
        name: "",
        date: Date(),
        description: "",
        photo: "",
        fichierInscription: "",
        inscriptionForm: ""
    )
*/

    // function to prepare an empty content to send to the EditForm
    func createNewEvent (_ id: String, _ eventType: String, _ clubId: String, _ contactId: String) -> Event {
        let newEvent = Event (
            id: id,
            clubId: clubId,
            eventType: eventType,
            name: "",
            startDate: Date(),
            endDate: Date().addingTimeInterval (TimeInterval( 60*60 )), // Add an hour by default
            createdBy: contactId,
            description: "",
            photo: "",
            fichierInscription: "",
            inscriptionForm: "" )
        return newEvent
    }


    // Load All EventTypes per club
    func loadEventTypes (for clubId: String) {
        isEventsLoading = true
        DataService.shared.fetchEventsTypesForClubId (withCLUBID: clubId) { fetchedEventsTypes, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.eventTypes = fetchedEventsTypes!
            }
            self.isEventsLoading = false
        }
    }

    // Load All EventTypes
    func loadAllEventTypes () {
        isEventsLoading = true
        DataService.shared.fetchAllEventsTypes { fetchedAllEventsTypes, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.eventTypes = fetchedAllEventsTypes!
            }
            self.isEventsLoading = false
        }
    }

    func saveEvent(_ event: Event, completion: @escaping (Bool) -> Void) {
        DataService.shared.saveEvent (event) { [self] success in
            if success {
                print("Event enregistré avec succès.")
                if let index = events.firstIndex(where: { $0.id == event.id }) {
                    print("Event Index : \(index)")
                    events[index] = event
                }
                completion(true)
            } else {
                print("Erreur lors de l'enregistrement")
                completion(false)
            }
        }
    }


    
    // Determine the icon to display for a given role
    func iconEventType(_ eventType: String) -> String {
        switch eventType.lowercased() {
        case "sortie":
            return "flag.checkered" // Example icon for Sortie
        case "assemblée":
            return "voiceover" // Example icon for Assemblée
        case "repas":
            return "cup.and.saucer.fill" // Example icon for Repas
        case "anniversary":
            return "birthday.cake.fill" // Example icon for Birthday
        default:
            return "questionmark.folder.fill" // Default icon
        }
    }


    func addEventToCalendar(title: String, startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        let eventStore = EKEventStore()
        
        // Request access to the calendar
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard granted else {
                completion(false, nil)
                return
            }
            
            // Create the event
            let event = EKEvent(eventStore: eventStore)
            event.title     = title
            event.startDate = startDate
            event.endDate   = endDate
            event.calendar  = eventStore.defaultCalendarForNewEvents
            
            // Save the event
            do {
                try eventStore.save(event, span: .thisEvent)
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
    }

    
}

