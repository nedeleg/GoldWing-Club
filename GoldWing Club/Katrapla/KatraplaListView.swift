//
//  KatraplaListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct KatraplaListView: View {
    @StateObject private var katraplaViewModel = KatraplaViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    @Environment(\.dismiss) var dismiss
    
    @State var mode: EditMode = .inactive //< -- Here
    
    var body: some View {
                VStack {
                    List {
                        ForEach(katraplaViewModel.filteredKatraplas) { katrapla in
                            if mode == .active {
                                ZStack {
                                    NavigationLink("", destination: KatraplaEditView (katrapla: katrapla))
                                        .opacity(0)
                                    KatraplaEditRow(katrapla: katrapla)
                                }
                            } else {
                                //NavigationLink(destination: KatraplaDetailView(katrapla: katrapla)) {
                                Link(destination: ((URL(string: katrapla.url_source) ?? URL(string: "#" ))! ) ) {
                                    KatraplaRow(katrapla: katrapla)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            // Convertir l'index en identifiant
                            if let index = indexSet.first {
                                let katraplaToDelete = katraplaViewModel.filteredKatraplas [index]
                                katraplaViewModel.deleteKatrapla (by: katraplaToDelete.id)
                            }
                        }
                    }
                    .toolbar {
                        if authViewModel.isSystemAdmin {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: KatraplaEditView (katrapla: katraplaViewModel.createNewKatrapla(UUID().uuidString) )) {
                                        Image(systemName: "plus")
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton().padding(.trailing, 20)
                            }
                        }
                    }
                    
                }
                .environment(\.editMode, $mode) //< -- Here
                .searchable(text: $katraplaViewModel.searchText, prompt: "Rechercher un Katrapla")
                .onAppear { katraplaViewModel.loadAllKatraplas() }
                .navigationTitle("Katrapla")
    }
    
    func didDismiss() {
        dismiss()
        // Handle the dismissing action.
    }
    
    
}

#Preview {
    KatraplaListView()
}
