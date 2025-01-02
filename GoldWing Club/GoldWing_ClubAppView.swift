//
//  GoldWing_ClubAppView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/21/24.
//

import SwiftUI

struct GoldWing_ClubAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        let _ = print("Load GoldWing_ClubAppView")

        if authViewModel.isSaving || authViewModel.isLoginLoading {
            ProgressView("Saving new user in GoldWing_ClubAppView ...")
        } else {
            Group {
                // User is authenticated and validated
                if let club = authViewModel.currentClub {
                    let _ = print ("Welcome to \(club.name), Region: \(club.region)")
                    MainSecureView(club: club ).environmentObject(authViewModel)
                    // User is authenticated
                } else if authViewModel.isUserAuthenticated {
                    let _ = print("User is Authenticated without and account ...")
                    MainView().environmentObject(authViewModel)
                } else {
                    // User is not authenticated
                    let _ = print("User is not authenticated")
                    MainView().environmentObject(authViewModel)
                }
            }
        } // End If isSaving
    }
}

#Preview {
    GoldWing_ClubAppView()
}
