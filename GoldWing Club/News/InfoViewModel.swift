//
//  InfoViewModel.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/23/24.
//

import Foundation

import SwiftUI

class InfoViewModel: ObservableObject {
    @Published var infos: [Info] = []
    @Published var isInfoLoading = false

    @Published var searchText: String = ""
    @State private var errorMessage: String? = nil

  
    var filteredInfos: [Info] {
        if searchText.isEmpty {
            return infos
        } else {
            return infos.filter { info in
                info.title.localizedStandardContains(searchText) ||
                info.description.localizedStandardContains(searchText)
            }
        }
    }
    
    func loadInfos() {
        print ("isInfoLoading Start: \(self.isInfoLoading)")
        DataService.shared.fetchAllInfos { fetchedInfos, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.infos = fetchedInfos ?? []

                self.infos.sort(by: { element1, element2 in
                    let comparisonResult = element1.date.compare(element2.date)
                    return comparisonResult == .orderedDescending
                })

            }
            self.isInfoLoading = false
        }
    }

    func deleteInfo(by InfoId: String) {
        DataService.shared.deleteInfo (withId: InfoId) { success in
            if success {
                if let index = self.infos.firstIndex(where: { $0.id == InfoId }) {
                    self.infos.remove(at: index)
                    print ("\(InfoId) deleted")
                }
            }
        }
    }

    // function to prepare an empty content to send to the EditForm
    func createNewInfo (_ id: String) -> Info {
        let newInfo = Info (
            id: id,
            title: "",
            auteur: "",
            date: Date(),
            description: "",
            photo: "",
            texte: "",
            link: "" )
        return newInfo
    }
    
    func saveInfo(_ info: Info, completion: @escaping (Bool) -> Void) {
        DataService.shared.saveInfo (info) { [self] success in
            if success {
                print("Info enregistré avec succès.")
                if let index = infos.firstIndex(where: { $0.id == info.id }) {
                    print("Infos Index : \(index)")
                    infos[index] = info
                }
                completion(true)
            } else {
                print("Erreur lors de l'enregistrement")
                completion(false)
            }
        }
    }

    
}
