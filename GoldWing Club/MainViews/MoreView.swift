//
//  MoreView.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/31/24.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        NavigationLink(destination: InfosListView()) {
                            Text("Infos").bold()
                        }
                        NavigationLink(destination: KatraplaListView()) {
                            Text("Katrapla").bold()
                        }
                        NavigationLink(destination: WingNewListView()) {
                            Text("WingNews").bold()
                        }
                    } header: {
                        Text("Informations")
                    }
                }
                .navigationTitle("Informations")
            }
            
        }
    }
}

#Preview {
    MoreView()
}
