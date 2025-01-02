//
//  ClubViewModel.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/19/24.
//

import Foundation

import SwiftUI


class ClubViewModel: ObservableObject {
    @Published var clubs: [Club] = []
    @Published var isLoading = false
    @Published var isAddingClub = false  // Check if we're asking to add a new club
    @Published var roles: [String] = []  // Roles from a Contacts

    @State var refreshView = false
    @State private var errorMessage: String? = nil
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = Locale(identifier: "fr")
        return dateFormatter
    }()
    
    
    func loadAllClubs() {
        isLoading = true
        DataService.shared.fetchAllClubs { fetchedClubs, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.clubs = fetchedClubs ?? []
            }
        }
        isLoading = false
    }

    func loadRoleFromContactPerClub(for clubId: String) {
        isLoading = true
        DataService.shared.fetchRoleFromContactPerClub (withCLUBID: clubId) { fetchedRoles, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.roles = fetchedRoles!
            }
        }
        isLoading = false
    }


    func saveClub(_ club: Club, completion: @escaping (Bool) -> Void) {
        DataService.shared.saveClub(club) { [self] success in
            if success {
                print("Club enregistré avec succès.")
                if let index = clubs.firstIndex(where: { $0.id == club.id }) {
                    print("Club Index : \(index)")
                    clubs[index] = club
                }
                completion(true)
            } else {
                print("Erreur lors de l'enregistrement")
                completion(false)
            }
        }
    }

    
        
    
    
    // Logique pour sélectionner une image (placeholder ici)
    func selectProfileImage() {
        print("Sélection d'une nouvelle image.")
        // Ajouter un UIImagePickerController si nécessaire
    }
        
    // Determine the image name for a given clubID
    func ecussonForClubId(_ clubID: String) -> String {
        let sanitizedClubID = clubID.lowercased().replacingOccurrences(of: " ", with: "_")
        return "Ecusson_\(sanitizedClubID)" // Format: "<clubID>_icon", e.g., "club1_icon"
    }

    // Determine the icon to display for a given role
    func iconForRole(_ role: String) -> String {
        switch role.lowercased() {
        case "events":
            return "calendar.circle.fill" // Example icon for office
        case "bureau":
            return "building.fill" // Example icon for office
        case "partner":
            return "engine.combustion.fill" // Example icon for partner
        case "adhérent":
            return "person.2.fill" // Example icon for subscriber
        default:
            return "person.fill" // Default icon
        }
    }

    // Determine the image name for a given clubID
    func carteForClubId(_ clubID: String) -> String {
        let sanitizedClubID = clubID.lowercased().replacingOccurrences(of: " ", with: "_")
        print ("Carte_\(sanitizedClubID)")
        return "Carte_\(sanitizedClubID)" // Format: "<clubID>_icon", e.g., "club1_icon"
    }

    
}
