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

var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" // Match your date format
    dateFormatter.timeZone = TimeZone(abbreviation: "CET") // Adjust to your timezone if needed
    return dateFormatter
}()

var dateHourFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // Match your date format
    dateFormatter.timeZone = TimeZone(abbreviation: "CET") // Adjust to your timezone if needed
    return dateFormatter
}()


let frenchDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = Locale(identifier: "fr")
        return dateFormatter
    }()

let frenchDateHourFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
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
    var nickName: String
    var clubId : String
    var role: String
    var userStatus: String
    var userProfile: String
    var title: String
    var gender: String
    var birthday: Date
    var cellPhone: String
    var homePhone: String
    var workPhone: String
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
    var startDate: Date
    var endDate: Date
    var createdBy: String
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
    var numero: String
    var title : String
    var url_source : String
    var photo : String
    var date: Date
}

struct WingNew: Identifiable {
    var id: String
    var numero: String
    var title : String
    var url_source : String
    var photo : String
    var date: Date
}


