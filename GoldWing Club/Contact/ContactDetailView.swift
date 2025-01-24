//
//  ContactDetailView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import SwiftUI

struct ContactDetailView: View {
    @StateObject private var contactViewModel = ContactViewModel()
    
    var contact: Contact
    
    var body: some View {
        List {
            // Contact Header
            Section {
                HStack {
                    // Display the contact's photo
                    if let url = URL(string: contact.photo) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                        .scaledToFit()
                        .frame(height: 80)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        // Display the contact's full name
                        Text("\(contact.firstName) \(contact.lastName)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        // Optional notes (e.g., roles in the club)
                        if !contact.nickName.isEmpty {
                            Text(contact.nickName)
                                .font(.subheadline)
                        }

                        // Optional notes (e.g., roles in the club)
                        if !contact.title.isEmpty {
                            Text(contact.title)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Optional notes (e.g., roles in the club)
                        if !contact.clubId.isEmpty {
                            let clubRegion = contactViewModel.clubs.first { $0.id == contact.clubId }?.region
                            Text(clubRegion ?? "")
                                .font(.headline)
                                .foregroundStyle(.orange)
                                .bold()
                        }
                        
                        // Optional notes (e.g., roles in the club)
                        Text(frenchDateFormatter.string(from: contact.birthday) )
                    }
                    .padding(.leading, 8)
                }
            }
            
            // Contact Information
            Section {
                if !contact.uid.isEmpty {
                    HStack {
                        Image(systemName: "person.text.rectangle.fill")
                            .foregroundColor(.orange)
                        Text(contact.uid)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }

                if !contact.cellPhone.isEmpty {
                    HStack {
                        Image(systemName: "iphone.gen3")
                            .foregroundColor(.green)
                        Menu {
                            Button(action: {
                                // Call
                                if let phoneURL = URL(string: "tel:\(contact.cellPhone)"),
                                   UIApplication.shared.canOpenURL(phoneURL) {
                                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                                }
                            }) {

                                Label("Call", systemImage: "phone.fill")
                                   
                            }
                            .foregroundColor(.green)
                            
                            Button(action: {
                                // SMS
                                if let smsURL = URL(string: "sms:\(contact.cellPhone)"),
                                   UIApplication.shared.canOpenURL(smsURL) {
                                    UIApplication.shared.open(smsURL, options: [:], completionHandler: nil)
                                }
                            }) {
                                Label("Send SMS", systemImage: "message.fill")
                            }
                            
                            Button(action: {
                                // WhatsApp
                                let whatsappURL = "https://wa.me/\(contact.cellPhone.filter { $0.isNumber })"
                                if let url = URL(string: whatsappURL),
                                   UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    print("WhatsApp is not installed or the URL is invalid.")
                                }
                            }) {
                                Label("Send WhatsApp", systemImage: "paperplane.fill")
                            }
                        } label: {
                            Text(contact.cellPhone)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }

                if !contact.homePhone.isEmpty {
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.indigo)
                        Button(action: {
                            if let phoneURL = URL(string: "tel:\(contact.homePhone)"),
                               UIApplication.shared.canOpenURL(phoneURL) {
                                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                            }
                        }) {
                            Text(contact.homePhone)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }

                if !contact.workPhone.isEmpty {
                    HStack {
                        Image(systemName: "teletype")
                            .foregroundColor(.purple)
                        Button(action: {
                            if let phoneURL = URL(string: "tel:\(contact.workPhone)"),
                               UIApplication.shared.canOpenURL(phoneURL) {
                                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                            }
                        }) {
                            Text(contact.workPhone)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }

                if !contact.email.isEmpty {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Button(action: {
                            // Email
                            if let emailURL = URL(string: "mailto:\(contact.email)"),
                               UIApplication.shared.canOpenURL(emailURL) {
                                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
                            } else {
                                print("Email client is not available or the URL is invalid.")
                            }
                        }) {
                            Text(contact.email)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                

                HStack (alignment: .top){
                    Image(systemName: "house.fill")
                        .foregroundColor(.orange)

                    VStack (alignment: .leading) {
                        if !contact.address.isEmpty {
                            Text(contact.address)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack {
                            if !contact.postalCode.isEmpty {
                                Text(contact.postalCode)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                if !contact.city.isEmpty {
                                    Text(contact.city)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        if !contact.country.isEmpty {
                                Text(contact.country)
                                    .font(.body)
                                    .foregroundColor(.primary)
                        }

                    }
                }
            }
            
            // Contact Notes
            Section {
                if !contact.notes.isEmpty {
                    HStack (alignment: .top) {
                        Image(systemName: "list.clipboard.fill")
                            .foregroundColor(.yellow)
                        Text(contact.notes)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            
        }
        .navigationTitle("\(contact.firstName) \(contact.lastName)")
        .onAppear {contactViewModel.loadAllClubs() }
    }
    
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: Contact(
            id: "1",
            uid : "1",
            firstName: "Jean",
            lastName: "Dupont",
            nickName: "JD",
            clubId: "Club10",
            role: "Bureau",
            userStatus: "Approved",
            userProfile: "User",
            title: "Président",
            gender: "M",
            birthday: Date(),
            cellPhone: "0612345678",
            homePhone: "0612345678",
            workPhone: "0612345678",
            email: "jean.dupont@example.com",
            address: "123 Rue Lafayette",
            city: "Paris",
            postalCode: "75011",
            country: "France",
            notes: "President of the club",
            photo: "https://via.placeholder.com/80"
        ) )
        .previewLayout(.sizeThatFits)
        
    }
}

/*
 #Preview {
 ContactDetailView()
 }
 */
