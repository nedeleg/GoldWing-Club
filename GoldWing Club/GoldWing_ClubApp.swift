//
//  GoldWing_ClubApp.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase


@main
struct GoldWing_ClubApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    // Declared the AppDelegate here
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //init() { FirebaseApp.configure() }

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            GoldWing_ClubAppView()
                .environmentObject(authViewModel)
                .task {
                    authViewModel.updateValidationStatus()
                }
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = Locale(identifier: "fr")
        return dateFormatter
    }()


struct Club: Identifiable {
    var id: String
    var name: String
    var region: String
    var email: String
    var members: Int
    var ecusson: String

    var departement: String
    var pageFacebook: String
    var photoRegion: String
}

struct Contact: Identifiable, Codable {
    var id: String
    var uid: String
    var firstName: String
    var lastName: String
    var clubId : String
    var role: String
    var title: String
    var gender: String
    var birthday: Date
    var phone: String
    var email: String
    var address: String
    var city: String
    var postalCode: String
    var country: String
    var notes: String
    var photo: String
//    var photo: String? = nil // URL de l'image dans Firebase Storage
    
    var fullName: String {
            "\(firstName) \(lastName)"
        }

}

struct Event: Identifiable {
    var id: String
    var clubId : String
    var eventType : String
    var name: String
    var date: Date
    var description : String
    var photo: String
    var fichierInscription: String
    var inscriptionForm: String
}

struct Info: Identifiable {
    var id: String
    var title : String
    var auteur : String
    var date: Date
    var description : String
    var photo: String
    var texte: String
    var link: String
}

struct EventType: Identifiable {
    var id: String
    var name : String
}

struct Katrapla: Identifiable {
    var id: String
    var title : String
    var url_source : String
    var photo : String
    var date: Date
}

struct WingNew: Identifiable {
    var id: String
    var title : String
    var url_source : String
    var photo : String
    var date: Date
}


