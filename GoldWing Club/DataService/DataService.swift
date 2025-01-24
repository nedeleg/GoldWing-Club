//
//  DataService.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import Foundation

import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

#if os(macOS)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

class DataService {
    static let shared = DataService()
    private let database = Database.database().reference()
    
    
    // MARK: - CRUD Operations for Contacts
    
    func fetchAllContacts(completion: @escaping ([Contact]) -> Void) {
        database.child("contacts").observeSingleEvent(of: .value) { snapshot in
            var contacts: [Contact] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let contactDict = childSnapshot.value as? [String: Any],
                   let contact = self.contactFromSnapshot(contactDict, id: childSnapshot.key) {
                    contacts.append(contact)
                }
            }
            completion(contacts)
        }
    }
    
    // CLoad one contact with UID
    func fetchContact(withUID uid: String, completion: @escaping (Contact?, Error?) -> Void) {
        database.child("contacts")
            .queryOrdered(byChild: "id")
            .queryEqual(toValue: uid)
            .observeSingleEvent(of: .value) { snapshot in
                if let firstChild = snapshot.children.allObjects.first as? DataSnapshot,
                    let contactDict = firstChild.value as? [String: Any],
                   let contact = self.contactFromSnapshot(contactDict, id: firstChild.key) {
                    completion(contact, nil)
                } else {
                    completion(nil, nil) // Aucun contact trouvé
                }
            } withCancel: { error in
                completion(nil, error)
            }
    }
    
    // Load all the contacts from a Club
    func fetchContactsForClub(withCLUBID clubId: String, completion: @escaping ([Contact]?, Error?) -> Void) {
        database.child("contacts")
            .queryOrdered(byChild: "clubId")
            .queryEqual(toValue: clubId)
            .observeSingleEvent(of: .value) { snapshot in
                var contacts: [Contact] = []
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let contactDict = childSnapshot.value as? [String: Any],
                       let contact = self.contactFromSnapshot(contactDict, id: childSnapshot.key) {
                        contacts.append(contact)
                    }
                }
                completion(contacts, nil)
            } withCancel: { error in
                completion(nil, error)
            }
    }
    
    
    ///  Load all contact assigned to a club and a role
    func fetchContactsForClubAndRole(withCLUBID clubId: String, withROLE role: String, completion: @escaping ([Contact]?, Error?) -> Void) {
        database.child("contacts")
            .queryOrdered(byChild: "clubId")
            .queryEqual(toValue: clubId)
            .observeSingleEvent(of: .value) { snapshot in
                var contacts: [Contact] = []
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let contactDict = childSnapshot.value as? [String: Any],
                       let contactClubID = contactDict["clubId"] as? String,
                       let contactRole = contactDict["role"] as? String,
                       contactClubID == clubId, // Filter by clubID
                       contactRole == role {   // Filter by role
                        if let contact = self.contactFromSnapshot(contactDict, id: childSnapshot.key) {
                            contacts.append(contact)
                        }
                    }
                }
                completion(contacts, nil)
            } withCancel: { error in
                completion(nil, error)
            }
    }
    
    /// Charge tous les contacts pour un club et un role donnés
    ///
    ///
    func fetchContactsForAnniversaries (withCLUBID clubId: String, withDATE date: Date, completion: @escaping ([Contact]?, Error?) -> Void) {
        
        
        func checkAnniversary(currentDate: Date, birthday: Date) -> Bool {
            guard
                let lastDayOfMonth = Calendar.current.date(bySetting: .day, value: 1, of: currentDate ),
                let firstOfMonth = Calendar.current.date(byAdding: DateComponents(month: -1, day: 1), to: lastDayOfMonth),
                let firstDayonNext2Month = Calendar.current.date(byAdding: DateComponents(month: 1, day: 1), to: lastDayOfMonth)
            else { return false }
            
            let currentYear = Calendar.current.component(.year, from: currentDate)
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = currentYear
            
            let month = calendar.component(.month, from: birthday)
            let day = calendar.component(.day, from: birthday)
            dateComponents.month = month
            dateComponents.day = day
            let NewBirthdayDate = calendar.date(from: dateComponents)
            
            if (firstOfMonth <= NewBirthdayDate! && NewBirthdayDate! <= firstDayonNext2Month) {
                return true
            } else {
                return false
            }
        }
        
        database.child("contacts")
            .queryOrdered(byChild: "clubId")
            .queryEqual(toValue: clubId)
            .observeSingleEvent(of: .value) { snapshot in
                var contacts: [Contact] = []
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let contactDict = childSnapshot.value as? [String: Any],
                       let contactClubID = contactDict["clubId"] as? String,
                       let contactBirthday = contactDict["birthday"] as? String,
                       contactClubID == clubId, // Filter by clubID,
                       let birthdayDate = dateFormatter.date(from: contactBirthday),
                       checkAnniversary (currentDate: Date.now, birthday: birthdayDate)
                    {   // Filter by birthdayDate
                        if let contact = self.contactFromSnapshot(contactDict, id: childSnapshot.key) {
                            contacts.append(contact)
                        }
                    }
                }
                completion(contacts, nil)
            } withCancel: { error in
                completion(nil, error)
            }
    }
    
    
    func saveContact(_ contact: Contact, completion: @escaping (Bool) -> Void) {
        
        let contactData = [
            "id" :          contact.id as String,
            "uid" :         contact.uid as String,
            "firstName" :   contact.firstName as String,
            "lastName" :    contact.lastName as String,
            "nickName" :    contact.nickName as String,
            "clubId" :      contact.clubId as String,
            "role" :        contact.role as String,
            "userStatus" :  contact.userStatus as String,
            "userProfile" : contact.userProfile as String,
            "title" :       contact.title as String,
            "gender" :      contact.gender as String,
            "birthday" :    dateFormatter.string(from: contact.birthday) as String,
            "cellPhone" :   contact.cellPhone as String,
            "homePhone" :   contact.homePhone as String,
            "workPhone" :   contact.workPhone as String,
            "email" :       contact.email as String,
            "address" :     contact.address as String,
            "city" :        contact.city as String,
            "postalCode" :  contact.postalCode as String,
            "country" :     contact.country as String,
            "notes" :       contact.notes as String,
            "photo" :       contact.photo as String
        ] as [String: Any]
        
        database.child("contacts").child(contact.id).setValue(contactData) { error, _ in
            completion(error == nil)
        }
    }
    
    func deleteContact (withId contactId: String, completion: @escaping (Bool) -> Void) {
        database.child("contacts").child(contactId).removeValue { error, _ in
            if let error = error {
                print("Error deleting contact: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Contact successfully deleted.")
                completion(true)
            }
        }
    }
    
    private func contactFromSnapshot(_ snapshot: [String: Any], id: String) -> Contact? {
        guard let firstName = snapshot["firstName"] as? String,
              let lastName = snapshot["lastName"] as? String,
              let clubId = snapshot["clubId"] as? String,
              let birthdayString = snapshot["birthday"] as? String,
              let uid = snapshot["uid"] as? String
        else {
            return nil
        }
        
        // Parse the birthday date string and ensure it is well formatted
        
        let birthday = dateFormatter.date(from: birthdayString) ?? Date(timeIntervalSince1970: 0) // Default to 1970 if parsing fails
        
        return Contact(
            id:             id,
            uid:            uid,
            firstName:      firstName,
            lastName:       lastName,
            nickName:       snapshot["nickName"] as? String ?? "",
            clubId:         clubId,
            role:           snapshot["role"] as? String ?? "",
            userStatus:     snapshot["userStatus"] as? String ?? "",
            userProfile:    snapshot["userProfile"] as? String ?? "",
            title:          snapshot["title"] as? String ?? "",
            gender:         snapshot["gender"] as? String ?? "",
            birthday:       birthday,
            cellPhone:      snapshot["cellPhone"] as? String ?? "",
            homePhone:      snapshot["homePhone"] as? String ?? "",
            workPhone:      snapshot["workPhone"] as? String ?? "",
            email:          snapshot["email"] as? String ?? "",
            address:        snapshot["address"] as? String ?? "",
            city:           snapshot["city"] as? String ?? "",
            postalCode:     snapshot["postalCode"] as? String ?? "",
            country:        snapshot["country"] as? String ?? "",
            notes:          snapshot["notes"] as? String ?? "",
            photo:          snapshot["photo"] as? String ?? ""
        )
    }
    
    
    
    // MARK: - CRUD Operations for Clubs
    
    func fetchAllClubs(completion: @escaping ([Club]?, Error?) -> Void) {
        database.child("clubs").observeSingleEvent(of: .value) { snapshot in
            var clubs: [Club] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let clubDict = childSnapshot.value as? [String: Any],
                   let club = self.clubFromSnapshot(clubDict, id: childSnapshot.key) {
                    clubs.append(club)
                }
            }
            completion(clubs, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }
    
    // Load Club with id
    func fetchClub(withID id: String, completion: @escaping (Club?, Error?) -> Void) {
        // Reference to the clubs node in the database
        let dbRef = Database.database().reference().child("clubs").child(id)
        
        // Observe the data at the specified club ID
        dbRef.observeSingleEvent(of: .value) { snapshot in
            // Check if the snapshot exists
            if let clubDict = snapshot.value as? [String: Any] {
                // Convert the dictionary to a Club object
                if let club = self.clubFromSnapshot(clubDict, id: id) {
                    completion(club, nil) // Return the Club object if successful
                } else {
                    completion(nil, nil) // No valid Club object found
                }
            } else {
                completion(nil, nil) // No data found at this ID
            }
        } withCancel: { error in
            completion(nil, error) // Return the error if the request fails
        }
    }
    
    func fetchRoleFromContactPerClub (withCLUBID clubId: String, completion: @escaping ([String]?, Error?) -> Void) {
        let dbRef = database.child("contacts")
        
        dbRef.queryOrdered(byChild: "clubId").queryEqual(toValue: clubId).observe(.value) { snapshot in
            var roleSet: Set<String> = []
            
            roleSet.insert ("Events") // First Items reserved for Events
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let contactDict = childSnapshot.value as? [String: Any],
                   let role = contactDict["role"] as? String {
                    roleSet.insert(role)
                }
            }
            let listOfRoles = Array(roleSet).sorted()
            
            completion(listOfRoles, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }
    
    func saveClub(_ club: Club, completion: @escaping (Bool) -> Void) {
        
        let clubData = [
            "id" : club.id as String,
            "name" : club.name as String,
            "region" : club.region as String,
            "email" : club.email as String,
            "members" : club.members as Int,
            "ecusson" : club.ecusson as String,
            "departement" : club.departement as String,
            "pageFacebook" : club.pageFacebook as String,
            "photoRegion" : club.photoRegion as String
        ] as [String: Any]
        
        database.child("clubs").child(club.id).setValue(clubData) { error, _ in
            completion(error == nil)
        }
    }
    
    
    //Convertit un dictionnaire Firebase en objet CLUB
    private func clubFromSnapshot(_ snapshot: [String: Any], id: String) -> Club? {
        guard
            let name = snapshot["name"] as? String,
            let members = snapshot["members"] as? Int
        else { return nil }
        
        return Club(
            id:             id,
            name:           name,
            region:         snapshot["region"] as? String ?? "",
            email:          snapshot["email"] as? String ?? "",
            members:        members,
            ecusson:        snapshot["ecusson"] as? String ?? "",
            departement:    snapshot["departement"] as? String ?? "",
            pageFacebook:   snapshot["pageFacebook"] as? String ?? "",
            photoRegion:    snapshot["photoRegion"] as? String ?? ""
        )
    }
    
    
    // MARK: - CRUD Operations for Events
    
    // Charge tous les Events
    func fetchAllEvents (completion: @escaping ([Event]?, Error?) -> Void) {
        database.child("events").observeSingleEvent(of: .value) { snapshot in
            var events: [Event] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let eventDict = childSnapshot.value as? [String: Any],
                   let event = self.eventFromSnapshot(eventDict, id: childSnapshot.key) {
                    events.append(event)
                }
            }
            completion(events, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }
    
    func fetchEventsTypesForClubId (withCLUBID clubId: String, completion: @escaping ([String]?, Error?) -> Void) {
        let dbRef = database.child("events")
        
        dbRef.queryOrdered(byChild: "clubId").queryEqual(toValue: clubId).observe(.value) { snapshot in
            var eventTypeSet: Set<String> = []
            
            eventTypeSet.insert ("Anniversary") // First Items reserved for EventTypes
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let eventDict = childSnapshot.value as? [String: Any],
                   let eventType = eventDict["eventType"] as? String {
                    eventTypeSet.insert(eventType)
                }
            }
            let listOfEventTypes = Array(eventTypeSet).sorted()
            
            completion(listOfEventTypes, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }
    
    // Load all Events for a Club and a specific Event Type
    func fetchEventsPerEventType(withEVENT eventType: String, completion: @escaping ([Event]?, Error?) -> Void) {
        database.child("events")
            .queryOrdered(byChild: "eventType")
            .queryEqual(toValue: eventType)
            .observeSingleEvent(of: .value) { snapshot in
                var events: [Event] = []
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let eventDict = childSnapshot.value as? [String: Any],
                       let event = self.eventFromSnapshot(eventDict, id: childSnapshot.key) {
                        events.append(event)
                    }
                }
                completion(events, nil)
            } withCancel: { error in
                completion(nil, error)
            }
    }
    
    // Charge tous les events pour un club et un évenement donnés
    // Load all Events for a Club and a specific Event Type
    func fetchEventsPerClubAndEventType(withCLUBID clubId: String, withEVENT eventType: String, completion: @escaping ([Event]?, Error?) -> Void) {
        database.child("events")
            .queryOrdered(byChild: "clubId")
            .queryEqual(toValue: clubId)
            .observeSingleEvent(of: .value) { snapshot in
                var events: [Event] = []
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let eventDict = childSnapshot.value as? [String: Any],
                       let eventEventType = eventDict["eventType"] as? String,
                       eventEventType == eventType {   // Filter by role
                        if let event = self.eventFromSnapshot(eventDict, id: childSnapshot.key) {
                            events.append(event)
                        }
                    }
                }
                completion(events, nil)
            } withCancel: { error in
                completion(nil, error)
            }
    }
    
    //Convertit un dictionnaire Firebase en objet EVENT
    private func eventFromSnapshot(_ snapshot: [String: Any], id: String) -> Event? {
        guard
            let name = snapshot["name"] as? String,
            let clubId = snapshot["clubId"] as? String,
            let eventType = snapshot["eventType"] as? String,
            let startDateString = snapshot["startDate"] as? String,
            let endDateString = snapshot["endDate"] as? String
            else { return nil }
        
        // Parse the  date string en ensure it well formatted        
        let startDate = dateHourFormatter.date(from: startDateString) ??  Date(timeIntervalSince1970: 0)
        let endDate = dateHourFormatter.date(from: endDateString) ??  Date(timeIntervalSince1970: 0)

        return Event(
            id:                 id,
            clubId:             clubId,
            eventType:          eventType,
            name:               name,
            lieu:               snapshot["lieu"] as? String ?? "",
            startDate:          startDate,
            endDate:            endDate,
            createdBy:          snapshot["createdBy"] as? String ?? "",
            description:        snapshot["description"] as? String ?? "",
            photo:              snapshot["photo"] as? String ?? "",
            fichierInscription: snapshot["fichierInscription"] as? String ?? "",
            inscriptionForm:    snapshot["inscriptionForm"] as? String ?? ""
        )
    }
    
    func saveEvent (_ event: Event, completion: @escaping (Bool) -> Void) {
        let eventData = [
            "id" :                  event.id as String,
            "clubId" :              event.clubId as String,
            "eventType" :           event.eventType as String,
            "name" :                event.name as String,
            "lieu" :                event.lieu as String,
            "startDate" :           dateHourFormatter.string(from: event.startDate) as String,
            "endDate" :             dateHourFormatter.string(from: event.endDate) as String,
            "createdBy" :           event.createdBy as String,
            "description" :         event.description as String,
            "photo" :               event.photo as String,
            "fichierInscription" :  event.fichierInscription as String,
            "inscriptionForm" :     event.inscriptionForm as String
        ] as [String: Any]
        
        database.child("events").child(event.id).setValue(eventData) { error, _ in
            completion(error == nil)
        }
    }
    
    
    func deleteEvent (withId eventId: String, completion: @escaping (Bool) -> Void) {
        database.child("events").child(eventId).removeValue { error, _ in
            if let error = error {
                print("Error deleting Event: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Event successfully deleted.")
                completion(true)
            }
        }
    }
    
    
    
    
    // MARK: - Info Management Methods (informations)
    
    // Charge tous les Events
    func fetchAllInfos (completion: @escaping ([Info]?, Error?) -> Void) {
        database.child("infos").observeSingleEvent(of: .value) { snapshot in
            var infos: [Info] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let infoDict = childSnapshot.value as? [String: Any],
                   let info = self.infoFromSnapshot(infoDict, id: childSnapshot.key) {
                    infos.append(info)
                }
            }
            completion(infos, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }
    
    //Convertit un dictionnaire Firebase en objet Inofrmation Info
    private func infoFromSnapshot(_ snapshot: [String: Any], id: String) -> Info? {
        guard
            let dateString = snapshot["date"] as? String
        else { return nil }
        
        let date = dateHourFormatter.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
        
        return Info(
            id: id,
            title: snapshot["title"] as? String ?? "",
            auteur: snapshot["auteur"] as? String ?? "",
            date: date,
            description: snapshot["description"] as? String ?? "",
            photo: snapshot["photo"] as? String ?? "",
            texte: snapshot["texte"] as? String ?? "",
            link: snapshot["link"] as? String ?? ""
        )
    }
    
    func saveInfo (_ info: Info, completion: @escaping (Bool) -> Void) {
        let infoData = [
            "id" : info.id as String,
            "title" : info.title as String,
            "auteur" : info.auteur as String,
            "date" : dateHourFormatter.string(from: info.date) as String,
            "description" : info.description as String,
            "photo" : info.photo as String,
            "texte" : info.texte as String,
            "link" : info.link as String
        ] as [String: Any]
        
        database.child("infos").child(info.id).setValue(infoData) { error, _ in
            completion(error == nil)
        }
    }
    
    func deleteInfo (withId infoId: String, completion: @escaping (Bool) -> Void) {
        database.child("infos").child(infoId).removeValue { error, _ in
            if let error = error {
                print("Error deleting information: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Information successfully deleted.")
                completion(true)
            }
        }
    }
    
    
    // MARK: - EventType Management Methods (Type of Events)
    
    // Catch all the Eventype from the eventsType Database
    func fetchAllEventsTypes (completion: @escaping ([String]?, Error?) -> Void) {
        database.child("eventTypes").observeSingleEvent(of: .value) { snapshot in
            var eventTypeSet: Set<String> = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let eventTypeDict = childSnapshot.value as? [String: Any],
                   let eventType = eventTypeDict["name"] as? String {
                    eventTypeSet.insert(eventType)
                }
            }
            let listOfEventTypes = Array(eventTypeSet).sorted()
            
            completion(listOfEventTypes, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }
    
    //Convertit un dictionnaire Firebase en objet Inofrmation Info
    private func eventTypeFromSnapshot(_ snapshot: [String: Any], id: String) -> EventType? {
        return EventType (
            id: id,
            name: snapshot["name"] as? String ?? ""
        )
    }
    
    // MARK: -  CRUD Operations for Katrapla
    
    // Load all Katraplas
    func fetchAllKatraplas (completion: @escaping ([Katrapla]?, Error?) -> Void) {
        database.child("katraplas").observeSingleEvent(of: .value) { snapshot in
            var katraplas: [Katrapla] = []
                        
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let katraplaDict = childSnapshot.value as? [String: Any],
                   let katrapla = self.katraplaFromSnapshot (katraplaDict, id: childSnapshot.key) {
                    
                    katraplas.append(katrapla)
                }
            }
            completion(katraplas, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }

    func saveKatrapla (_ katrapla: Katrapla, completion: @escaping (Bool) -> Void) {
        let katraplaData = [
            "id":       katrapla.id as String,
            "numero":   katrapla.numero as String,
            "title":    katrapla.title as String,
            "url_source": katrapla.url_source as String,
            "photo" :   katrapla.photo as String,
            "date" :    dateFormatter.string(from: katrapla.date) as String
        ] as [String: Any]
        
        database.child("katraplas").child(katrapla.id).setValue(katraplaData) { error, _ in
            completion(error == nil)
        }
    }
    
    func deleteKatrapla (withId katraplaId: String, completion: @escaping (Bool) -> Void) {
        database.child("katraplas").child(katraplaId).removeValue { error, _ in
            if let error = error {
                print("Error deleting information: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Information successfully deleted.")
                completion(true)
            }
        }
    }
    
    //Convertit un dictionnaire Firebase en objet Inofrmation Info
    private func katraplaFromSnapshot(_ snapshot: [String: Any], id: String) -> Katrapla? {
        guard
            let dateString = snapshot["date"] as? String
        else { return nil }
        
        let date = dateFormatter.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
        
        return Katrapla (
            id:         id,
            numero:     snapshot["numero"] as? String ?? "",
            title:      snapshot["title"] as? String ?? "",
            url_source: snapshot["url_source"] as? String ?? "",
            photo:      snapshot["photo"] as? String ?? "",
            date:       date
        )
    }
    
    
    // MARK: -  CRUD Operations for WinfNews

    
    // Load all WingNews
    func fetchAllWingNews (completion: @escaping ([WingNew]?, Error?) -> Void) {
        database.child("wingNews").observeSingleEvent(of: .value) { snapshot in
            var wingNews: [WingNew] = []
                        
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let wingNewDict = childSnapshot.value as? [String: Any],
                   let wingNew = self.wingNewFromSnapshot (wingNewDict, id: childSnapshot.key) {
                    
                    wingNews.append(wingNew)
                }
            }
            completion(wingNews, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }

    func saveWingNew (_ wingNew: WingNew, completion: @escaping (Bool) -> Void) {
        let wingNewData = [
            "id":       wingNew.id as String,
            "numero":   wingNew.numero as String,
            "title":    wingNew.title as String,
            "url_source": wingNew.url_source as String,
            "photo":    wingNew.photo as String,
            "date":     dateFormatter.string(from: wingNew.date) as String
        ] as [String: Any]
        
        database.child("wingNews").child(wingNew.id).setValue(wingNewData) { error, _ in
            completion(error == nil)
        }
    }
    
    func deleteWingNew (withId wingNewId: String, completion: @escaping (Bool) -> Void) {
        database.child("wingNews").child(wingNewId).removeValue { error, _ in
            if let error = error {
                print("Error deleting information: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Information successfully deleted.")
                completion(true)
            }
        }
    }

    
    //Convertit un dictionnaire Firebase en objet Inofrmation Info
    private func wingNewFromSnapshot (_ snapshot: [String: Any], id: String) -> WingNew? {
        guard
            let dateString = snapshot["date"] as? String
        else { return nil }
        
        let date = dateFormatter.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
        
        return WingNew (
            id:         id,
            numero:     snapshot["numero"] as? String ?? "",
            title:      snapshot["title"] as? String ?? "",
            url_source: snapshot["url_source"] as? String ?? "",
            photo:      snapshot["photo"] as? String ?? "",
            date:       date
        )
    }
    


    
    // MARK: -  CRUD Operations for Images / Photos

    func uploadProfileImage (_ contact: Contact, _ profileImage: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = profileImage else {
                completion(.failure(NSError(domain: "NoImage", code: -1, userInfo: [NSLocalizedDescriptionKey: "No image selected"])))
                print ("NoImage")

                return
            }

            // Convert UIImage to Data
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
                    print ("Compression Error")
                return
            }

            // Generate a unique filename
            let filename = "\(contact.id)-profile.jpg"

            // Reference to Firebase Storage
            let storageRef = Storage.storage().reference().child("profileImages/\(filename)")

            // Upload the image
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    completion(.failure(error))
                    print ("Put Error : \(error)")
                    return
                }

                // Retrieve the download URL
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        print ("Retreive Error : \(error)")
                    } else if let url = url {
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    
    func deleteProfileImage (withId photoId: String, completion: @escaping (Bool) -> Void) {
        // Get a reference to the file
                
        // Generate a unique filename
        let filename = "\(photoId)-profile.jpg"
        
        // Reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("profileImages/\(filename)")
        
        // Delete the file
        storageRef.delete { error in
            if let error = error as NSError? {
                if error.domain == StorageErrorDomain, let errorCode = StorageErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .unauthorized:
                        print("User does not have permission to perform this action on file. \(error.localizedDescription)")
                    case .objectNotFound:
                        print("File not found.")
                    default:
                        print("Error deleting file: \(error.localizedDescription)")
                    }
                    
                }
                completion(false)
            } else {
                print("File successfully deleted.")
                completion(true)

            }
        }
    }
    
}
