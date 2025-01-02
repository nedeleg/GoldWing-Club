//
//  LoginView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/22/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var contactViewModel = ContactViewModel()
    
    //    @State private var isUserAuthenticated = false
    @State private var userDisplayName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("GoldWing2020logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 5)
                }
                            
                VStack {
                    if authViewModel.isUserAuthenticated  {
                        // Redirection vers l'application après connexion
                        
                        Text("\(authViewModel.currentUser?.displayName ?? "Utilisateur inconnu")")
                            .font(.title)
                            .padding(.bottom, 5)
                            .foregroundStyle(.yellow)
                            .bold()
                        
                        if authViewModel.isUserValidated {
                            List {
                                Section {
                                    ZStack {
                                        NavigationLink(destination: ContactEditView (contact:  authViewModel.currentContact!)) {}
                                        HStack {
                                            Text("Mon Compte").bold()
                                            Spacer()
                                            Image(systemName: "gearshape" )
                                        }
                                    }
                                    
                                    ZStack {
                                        NavigationLink(destination: EventTypeListView(club: authViewModel.currentClub!))  {}
                                        HStack {
                                            //Text("Région \(authViewModel.currentClub!.region)").bold()
                                            Text("Mon Club").bold()
                                            Spacer()
                                            Image(systemName: "globe.europe.africa" )
                                        }
                                    }
                                    
                                    ZStack {
                                        NavigationLink(destination: AboutView() ) {}
                                        HStack {
                                            Text("Notes").bold()
                                            Spacer()
                                            Image(systemName: "books.vertical" )
                                        }
                                    }

                                } header: {
                                    Text("Prolie")
                                }
                            }
                            .frame(height: 205)
                            .scrollDisabled(true)
                            //.listStyle(PlainListStyle())
                            
                            
                        } else {
                            if let userProfile = authViewModel.currentContact {
                                Text("Votre compte est en attente de validation")
                                    .font(.title2)
                                    .foregroundStyle(.red)
                                    .padding(.bottom, 20)
                                    .multilineTextAlignment(.center)
                                
                                List {
                                    Section {
                                        ZStack {
                                            NavigationLink(destination: ContactEditView (contact: userProfile )) {}
                                            // NavigationLink(destination: ContactListView() ) {}
                                            HStack {
                                                Text("Mon Compte").bold()
                                                Spacer()
                                                Image(systemName: "gearshape" )
                                            }
                                        }
                                        
                                    } header: {
                                        Text("Profile")
                                    }
                                }
                                .frame(height: 115)
                                .scrollDisabled(true)
                                //.listStyle(PlainListStyle())
                            } else {
                                Text("Données inaccessibles !")
                                    .font(.title2)
                                    .foregroundStyle(.red)
                                    .padding(.bottom, 20)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        Button(action: authViewModel.logout) {
                            HStack {
                                // Image(systemName: "g.circle")
                                Text("Déconnexion du GoldWing Club")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    } else {
                        // Background view
                        //                Color.white.ignoresSafeArea()
                        
                        Text("Bienvenue sur le GoldWing Club")
                            .font(.largeTitle)
                            .padding(.bottom, 20)
                        
                        // Google Sign-In Button
                        Button(action: {
                            authViewModel.signInWithGoogle()
                        }) {
                            Text("Identification avec Google")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .navigationTitle("GoldWing Club")
    }
    
    
}

#Preview {
    ProfileView()
}
