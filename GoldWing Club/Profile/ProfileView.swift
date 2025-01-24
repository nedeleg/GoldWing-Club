//
//  LoginView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/22/24.
//

import SwiftUI
import GoogleSignInSwift // Button for google
import AuthenticationServices // For Apple sign-In

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var contactViewModel = ContactViewModel()
    
    //    @State private var isUserAuthenticated = false
    @State private var userDisplayName = ""
    @State var showingAlert: Bool = false

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
                        
                        Text("\(authViewModel.currentContact?.fullName ?? "Utilisateur inconnu")")
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
                                            if let userId = authViewModel.currentContact?.id {
                                                Button(action: {
                                                    showingAlert = true
                                                }) {
                                                    Image(systemName: "delete.left.fill").foregroundColor(.red) // Edit icon
                                                }
                                                .buttonStyle(BorderlessButtonStyle()) // Ensure the button doesn't interfere with row taps
                                                .alert("Suppression de mon compte ?", isPresented: $showingAlert) {
                                                    Button("Confirmer", role: .destructive) {
                                                        let dispatchGroup = DispatchGroup()
                                                        // Attempt to delete the contact
                                                        dispatchGroup.enter()
                                                        contactViewModel.deleteContact(by: userId) { success in
                                                            authViewModel.logout()
                                                        }
                                                    }
                                                    Button("Annuler", role: .cancel) {}
                                                }
                                            }
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
                                    Text("Profile")
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
                                                if let userId = authViewModel.currentContact?.id {
                                                    Button(action: {
                                                        showingAlert = true
                                                    }) {
                                                        Image(systemName: "delete.left.fill").foregroundColor(.red) // Edit icon
                                                    }
                                                    .buttonStyle(BorderlessButtonStyle()) // Ensure the button doesn't interfere with row taps
                                                    .alert("Suppression de mon compte ?", isPresented: $showingAlert) {
                                                        Button("Confirmer", role: .destructive) {
                                                            contactViewModel.deleteContact(by: userId) { success in
                                                                authViewModel.logout()
                                                            }
                                                        }
                                                        Button("Annuler", role: .cancel) {}
                                                    }
                                                }
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
                        
                        VStack {
                            // Apple Sign-In Button
                            SignInWithAppleButton(
                                .signIn,
                                onRequest: { request in
                                    request.requestedScopes = [.fullName, .email]
                                },
                                onCompletion: { result in
                                    // Pass the `Result` directly to the function
                                    authViewModel.handleAppleSignIn(authResults: result)
                                }
                            )
                            .signInWithAppleButtonStyle(.white)
                            .cornerRadius(8)
                            .frame(width: 250, height: 40)
                            .padding()

                            // Google Sign-In Button
                            GoogleSignInButton (scheme: .light,
                                                style: .wide,
                                                state: .normal,
                                                action: {
                                authViewModel.signInWithGoogle()
                            })
                            .cornerRadius(8)
                            .frame(width: 250, height: 40, alignment: .centerFirstTextBaseline)
                            .padding()

                        } // Vstack
                        
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
