//
//  KatraplaViewModel.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import Foundation

import SwiftUI

class KatraplaViewModel: ObservableObject {
    @Published var katraplas: [Katrapla] = []
    @Published var isKatraplaLoading = false
    
    @Published var searchText: String = ""
    @State private var errorMessage: String? = nil

    var filteredKatraplas: [Katrapla] {
        if searchText.isEmpty {
            return katraplas
        } else {
            return katraplas.filter { katrapla in
                katrapla.title.localizedStandardContains(searchText)
            }
        }
    }

    func loadAllKatraplas() {
        isKatraplaLoading = true
        DataService.shared.fetchAllKatraplas { fetchedKatraplas, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.katraplas = fetchedKatraplas ?? []
                
                self.katraplas.sort(by: { element1, element2 in
                    let comparisonResult = element1.date.compare(element2.date)
                    return comparisonResult == .orderedDescending
                })
            }
            self.isKatraplaLoading = false
        }
    }

    func deleteKatrapla (by katraplaId: String) {
        isKatraplaLoading = true
        DataService.shared.deleteKatrapla (withId: katraplaId) { success in
            if success {
                if let index = self.katraplas.firstIndex(where: { $0.id == katraplaId }) {
                    self.katraplas.remove(at: index)
                    print ("\(katraplaId) deleted")
                }

            }
            self.isKatraplaLoading = false
        }
    }

    // function to prepare an empty content to send to the EditForm
    func createNewKatrapla (_ id: String) -> Katrapla {
        let newKatrapla = Katrapla (
            id: id,
            numero: "",
            title: "",
            url_source: "",
            photo: "",
            date: Date() )
        return newKatrapla
    }
    
    func saveKatrapla(_ katrapla: Katrapla, completion: @escaping (Bool) -> Void) {
        isKatraplaLoading = true
        DataService.shared.saveKatrapla (katrapla) { [self] success in
            if success {
                print("Katrapla enregistré avec succès.")
                if let index = katraplas.firstIndex(where: { $0.id == katrapla.id }) {
                    print("Katraplas Index : \(index)")
                    katraplas[index] = katrapla
                }
                completion(true)
                self.isKatraplaLoading = false
            } else {
                print("Erreur lors de l'enregistrement")
                completion(false)
                self.isKatraplaLoading = false
            }
        }
    }

}
