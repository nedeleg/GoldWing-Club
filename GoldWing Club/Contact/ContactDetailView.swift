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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                        if !contact.role.isEmpty {
                            Text(contact.title)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Optional notes (e.g., roles in the club)
                        if !contact.clubId.isEmpty {
                            Text(contact.clubId)
                                .font(.headline)
                                .foregroundStyle(.yellow)
                                .bold()
                        }
                        
                        // Optional notes (e.g., roles in the club)
                        Text(contactViewModel.dateFormatter.string(from: contact.birthday) )
                    }
                    .padding(.leading, 8)
                }
                
                Divider()
                
                // Contact Information
                VStack(alignment: .leading, spacing: 8) {
                    if !contact.phone.isEmpty {
                        HStack {
                            Image(systemName: "person.text.rectangle.fill")
                                .foregroundColor(.orange)
                            Text(contact.uid)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    if !contact.phone.isEmpty {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                            Text(contact.phone)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    if !contact.email.isEmpty {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                            Text(contact.email)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    if !contact.address.isEmpty {
                        HStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.orange)
                            Text(contact.address)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    HStack {
                        if !contact.postalCode.isEmpty {
                            HStack {
                                Spacer()
                                    .frame(width: 33)
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
                    }
                    if !contact.country.isEmpty {
                        HStack {
                            Image(systemName: "globe.europe.africa.fill")
                                .foregroundColor(.blue)
                            Text(contact.country)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    if !contact.notes.isEmpty {
                        HStack {
                            Image(systemName: "list.clipboard.fill")
                                .foregroundColor(.yellow)
                            Text(contact.notes)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 2))
            .padding(.horizontal)
            .navigationTitle("\(contact.firstName) \(contact.lastName)")
            
            Spacer()
        }
    }
    
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: Contact(
            id: "1",
            uid : "1",
            firstName: "Jean",
            lastName: "Dupont",
            clubId: "Club10",
            role: "Bureau",
            title: "Président",
            gender: "M",
            birthday: Date(),
            phone: "0612345678",
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
