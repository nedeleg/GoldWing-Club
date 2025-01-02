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
                        if mode == .active {
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
                    if authViewModel.isUserAdmin {
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
