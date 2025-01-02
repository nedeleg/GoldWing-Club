//
//  WingNewsListView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import SwiftUI

struct WingNewListView: View {
    @StateObject private var wingNewViewModel = WingNewViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    @Environment(\.dismiss) var dismiss
    
    @State var mode: EditMode = .inactive //< -- Here
    
    
    var body: some View {
            VStack {
                List {
                    ForEach(wingNewViewModel.filteredWingNews) { wingNew in
                        if mode == .active {
                            ZStack {
                                NavigationLink("", destination: WingNewEditView (wingNew: wingNew))
                                    .opacity(0)
                                WingNewEditRow(wingNew: wingNew)
                            }
                        } else {
                            //NavigationLink(destination: WingNewDetailView(wingNew: wingNew)) {
                            Link(destination: (URL(string: wingNew.url_source) ?? URL(string: "#"))!  ) {
                                WingNewRow(wingNew: wingNew)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        // Convertir l'index en identifiant
                        if let index = indexSet.first {
                            let wingNewToDelete = wingNewViewModel.filteredWingNews [index]
                            wingNewViewModel.deleteWingNew (by: wingNewToDelete.id)
                        }
                    }
                }
                .toolbar {
                    if authViewModel.isUserAdmin {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: WingNewEditView (wingNew: wingNewViewModel.createNewWingNew (UUID().uuidString) )) {
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
            .searchable(text: $wingNewViewModel.searchText, prompt: "Rechercher une WingNew")
            .onAppear { wingNewViewModel.loadAllWingNews() }
            .navigationTitle("WingNews")
                    
    }
    
    func didDismiss() {
        dismiss()
        // Handle the dismissing action.
    }
}

#Preview {
    WingNewListView ()
}
