//
//  AuthViewModel.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/21/24.
//

import Foundation

import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices // Signin with Apple

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    // Variable publiée pour suivre l'état de l'authentification
    @Published var errorMessage: String? = nil
    
    @Published var isLoginLoading: Bool = false
    @Published var isSaving = false // To show a loading spinner during save
    
    @Published var isUserAuthenticated: Bool = false// User is sign in using Google
    @Published var isUserValidated: Bool = false    // User has been validated by Admin
    @Published var isClubAdmin: Bool = false        // User is an Club Admin
    @Published var isSystemAdmin: Bool = false      // User is an System Admin

    @Published var currentUser: User? = nil         // Current Google User
    @Published var currentClubId: String? = nil     // Current Club Id
    @Published var currentClub: Club? = nil         // Define a single Club here
    @Published var currentContact: Contact? = nil   // Define a single Contact here
    
    // Initialisation : Vérification de l'état de l'utilisateur connecté
    private var contactViewModel: ContactViewModel
    init() {
        self.contactViewModel = ContactViewModel() // Valeur par défaut
        // Appeler la méthode après avoir initialisé toutes les propriétés
        checkAuthentication()
    }
    
    
    // Vérifie si un utilisateur est connecté via Firebase. Si un utilisateur est connecté, ses informations sont stockées dans currentUser.
    func checkAuthentication() {
        if let user = Auth.auth().currentUser {
            // Utilisateur connecté
            self.currentUser = user
            self.isUserAuthenticated = true
        } else {
            // Aucun utilisateur connecté
            self.currentUser = nil
            self.isUserAuthenticated = false
        }
    }
    
    func signInWithGoogle() {
        isLoginLoading = true
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Missing Firebase client ID")
            isLoginLoading = false
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn (withPresenting: getRootViewController()) { signInResult, error in
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
                self.isLoginLoading = false
                return
            }
            
            guard let result = signInResult else {
                print("No result from Google Sign-In")
                self.isLoginLoading = false
                return
            }
            
            let idToken = result.user.idToken?.tokenString
            let accessToken = result.user.accessToken.tokenString
            
            guard let idToken = idToken else {
                print("No ID token found")
                self.isLoginLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Firebase Authentication Error: \(error.localizedDescription)")
                        self.errorMessage = "Erreur de connexion : \(error.localizedDescription)"
                        self.isUserAuthenticated = false
                        self.isLoginLoading = false
                        
                    } else if let user = authResult?.user  {
                        
                        print("User \(user) signed in successfully!")
                        self.currentUser = user
                        
                        self.isUserAuthenticated = true
                        
                        // Ajoutez votre logique après la connexion ici
                        // Vérififier si l'utilisateur à un compte validé
                        //self.updateValidationStatus()
                        
                        if let currentUID = Auth.auth().currentUser?.uid {
                            
                            print ("The currentUID is  \(currentUID)")
                            print ("The isLoginLoading is  \(self.isLoginLoading)")
                            
                            // Check if the user has been validate by the Admin
                            // and then Load all data from the firebase in the club Cobject
                            self.updateValidationStatus()
                        }
                    }
                }
            }
        }
    }
    

    func handleAppleSignIn(authResults: Result<ASAuthorization, Error>) {
        
        isLoginLoading = true

        switch authResults {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let idToken = appleIDCredential.identityToken
                let rawNonce = UUID().uuidString // Generate a nonce

                guard let tokenString = idToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
                    print("Unable to fetch identity token")
                    self.isLoginLoading = false
                    return
                }

                // Firebase Sign-In with Apple (Updated to use the new method)
                let credential = OAuthProvider.credential(
                    providerID: AuthProviderID.apple,
                    idToken: tokenString,
                    rawNonce: rawNonce,
                    accessToken: nil
                )
                
                Auth.auth().signIn (with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase Sign-In with Apple failed: \(error.localizedDescription)")
                        self.isLoginLoading = false
                        return
                    }
                    print("User is signed in with Apple: \(authResult?.user.uid ?? "No UID")")

                    if let user = authResult?.user  {
                        self.currentUser = user
                        self.isUserAuthenticated = true

                        if let currentUID = Auth.auth().currentUser?.uid {
                            
                            print ("The currentUID is  \(currentUID)")
                            print ("The isLoginLoading is  \(self.isLoginLoading)")

                            // Check if the user has been validate by the Admin
                            // and then Load all data from the firebase in the club Cobject
                            self.updateValidationStatus()
                        }
                    }
                }
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
    
    
    func getRootViewController() -> UIViewController {
        guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            fatalError("Unable to find the root view controller")
        }
        return rootVC
    }



    // function to prepare an empty content to send to the EditForm
    func createNewUserContact(_ userId: String, _ firstName: String, _ lastName: String, _ email: String, _ photo: String) {
        var newUser = contactViewModel.createNewContact(userId,"FedeFR")
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.email = email
        newUser.photo = photo
        saveContact(newUser) { success in
            if success {
                // Close the view on success
                self.currentContact = newUser
            } else {
                self.errorMessage = "Erreur lors de l'enregistrement. Veuillez réessayer."
            }
        }
    }

    // Saving just for the creation of the currentContact
    func saveContact(_ contact: Contact, completion: @escaping (Bool) -> Void) {
        isSaving = true
        DataService.shared.saveContact(contact) { [self] success in
            if success {
                print("Contact enregistré avec succès.")
                completion(true)
                isSaving = false
            } else {
                print("Erreur lors de l'enregistrement")
                completion(false)
                isSaving = false
            }
        }
    }

    func loadTheCurrentClub (clubId: String) {
        // Logique pour déterminer si l'utilisateur est affilié à un club
        // après validation par l'administrateur
        
        DataService.shared.fetchClub (withID: currentClubId!) { fetchClub, error in
            if let error = error {
                print("Error fetching club: \(error.localizedDescription)")
            } else if let club = fetchClub {
                DispatchQueue.main.async {
                    self.currentClub = club
                    print("Club fetched successfully: \(club.name)")
                }
            } else {
                print("No club found.")
            }
        }
    }


    // Méthode pour mettre à jour isUserValidated à partir de contact
       func updateValidationStatus() {
           // Logique pour déterminer si l'utilisateur est validé
           // role est égale à "En cours de validation"",
           // le compte est en attente de validation par l'adminstrateur

           // Vérififier si l'utilisateur à un compte crée dans Firebase
           if let currentUID = Auth.auth().currentUser?.uid {

               print (" updateValidationStatus")
               print (" currentUID \(currentUID)")
               print ("The isLoginLoading is  \(self.isLoginLoading)")

               DataService.shared.fetchContact(withUID: currentUID) { fetchedContact, error in

                   print (" Checking Contact")

                   DispatchQueue.main.async { [self] in
                       if let error = error {
                           self.errorMessage = error.localizedDescription

                           print (" Error in DB")

                           self.isLoginLoading = false

                       } else {

                           print (" Mo Error searching")

                           self.currentContact = fetchedContact

                           // User is loggedIn, we're checking if he is created in Firebase with same ID
                           if currentContact?.id == nil {

                               print (" Contact is not created")

                               // User is loggendIn and need to be created as blanck user in Firebase
                               isSaving = true
                               
                               let email = Auth.auth().currentUser?.email
                               
                               var firstName: String = ""
                               var lastName: String = ""
                               var photo: String = ""

                               if let displayName: String = Auth.auth().currentUser?.displayName {
                                   let fullName = displayName.components(separatedBy: " ")
                                   firstName = fullName[0]
                                   lastName = fullName[1].isEmpty ? "" : fullName[1]
                               }
                               if let photoUrl = Auth.auth().currentUser?.photoURL {
                                   photo = photoUrl.absoluteString
                               }

                               createNewUserContact (currentUID, firstName, lastName , email ?? "", photo) // Create the blank contact

                               
                               self.isUserValidated = false
                               self.isLoginLoading = false

                               print (" Contact is creating")

                           } else if let currentContact = self.currentContact, currentContact.id == Auth.auth().currentUser?.uid  {

                               print (" Contact no contacit ID found")

                               // Contact is created but user may be waiting for validation
                               self.currentClubId = self.currentContact?.clubId
                               
                               // if role is not Approved then the user is created and waiing for aapproval by admin
                               self.isUserValidated = self.currentContact!.userStatus == "Approved"
                               
                               // Check role is Admin - Can create & edit contact, Event, Club, Info,...
                               self.isClubAdmin = self.currentContact!.role == "Admin"
                               self.isSystemAdmin = self.currentContact!.userProfile == "SystemAdmin"

                               if self.isUserValidated {
                                   print ("User has been validated ")
                                   loadTheCurrentClub (clubId: currentClubId!)
                               }
                               self.isLoginLoading = false
                           }
                       }
                   }
               }
           }
       }
    
    // Logout user
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isUserAuthenticated = false
                self.currentClub = nil
                self.currentUser = nil
                self.currentContact = nil
                self.isClubAdmin = false
                self.isSystemAdmin = false
                self.updateValidationStatus()
                print ("Sign-out in progress")
            }
        } catch {
            self.errorMessage = "Erreur lors de la déconnexion : \(error.localizedDescription)"
        }
    }

    
    
    
    

}
