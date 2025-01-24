//
//  ClubListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/19/24.
//

import SwiftUI

struct ClubListView: View {
    @StateObject private var clubViewModel = ClubViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    
    @State private var selectedClub: Club? = nil
    @State private var errorMessage: String?
    @State var mode: EditMode = .inactive //< -- Here
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(clubViewModel.clubs) { club in
                        // Check the user is either a SystemAdmin
                        // or a ClubAdmin who can update only his club
                        if mode == .active && (authViewModel.isSystemAdmin || (authViewModel.isClubAdmin && club.id == authViewModel.currentClubId) ) {
                            ZStack {
                                    NavigationLink("", destination: ClubEditView (club: club) )
                                    .opacity(0)
                                    ClubEditRow(club: club)
                            }

                        } else {
                            // Standard navigation behavior
                            NavigationLink(destination: ClubDetailView(club: club)) {
                                ClubRow(club: club)
                            }
                        }
                    }
                    //.onDelete(perform: clubViewModel.deleteClub)
                }
                .toolbar {
                    if authViewModel.isSystemAdmin || authViewModel.isClubAdmin {
                        ToolbarItem (placement: .navigationBarTrailing) {
                            EditButton().padding(.trailing, 20)
                        }
                    }
                }
            }
            .environment(\.editMode, $mode) //< -- Here
            .navigationTitle( mode == .active ? "Edit Club" : "Club")
            .onAppear {clubViewModel.loadAllClubs() }
            //        }

        }
    }
}

#Preview {
    ClubListView()
}
