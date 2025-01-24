//
//  InfosListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/22/24.
//

import SwiftUI

struct InfosListView: View {
    @StateObject private var infoViewModel = InfoViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedInfo: Info? = nil
    @State var mode: EditMode = .inactive //< -- Here
    
    var body: some View {
        
        VStack {
            if infoViewModel.isInfoLoading {
                ProgressView("Chargement...")
            } else {
                
                List {
                    ForEach(infoViewModel.filteredInfos) { info in
                        if mode == .active {
                            ZStack {
                                NavigationLink("", destination: InfoEditView (info: info))
                                    .opacity(0)
                                InfoEditRow(info: info)
                            }
                        } else {
                            NavigationLink(destination: InfoDetailView(info: info)) {
                                InfoRow(info: info)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        // Convertir l'index en identifiant
                        if let index = indexSet.first {
                            let infoToDelete = infoViewModel.filteredInfos [index]
                            infoViewModel.deleteInfo (by: infoToDelete.id)
                        }
                    }
                }
            }
        }
        .environment(\.editMode, $mode) //< -- Here
        .searchable(text: $infoViewModel.searchText, prompt: "Rechercher une news")
        .onAppear { infoViewModel.loadInfos() }
        .navigationTitle("News")
    }
    
    func didDismiss() {
        dismiss()
        // Handle the dismissing action.
    }
    
    
}

#Preview {
    InfosListView()
}
