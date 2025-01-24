//
//  WingNewViewModel.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/29/24.
//

import Foundation


import SwiftUI

class WingNewViewModel: ObservableObject {
    @Published var wingNews: [WingNew] = []
    @Published var isWingNewLoading = false
    
    @Published var searchText: String = ""
    @State private var errorMessage: String? = nil

    var filteredWingNews: [WingNew] {
        if searchText.isEmpty {
            return wingNews
        } else {
            return wingNews.filter { wingNew in
                wingNew.title.localizedStandardContains(searchText)
            }
        }
    }

    func loadAllWingNews() {
        isWingNewLoading = true
        DataService.shared.fetchAllWingNews { fetchedWingNews, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.wingNews = fetchedWingNews ?? []

                self.wingNews.sort(by: { element1, element2 in
                    let comparisonResult = element1.date.compare(element2.date)
                    return comparisonResult == .orderedDescending
                })

            }
            self.isWingNewLoading = false
        }
    }

    func deleteWingNew (by wingNewId: String) {
        isWingNewLoading = true
        DataService.shared.deleteWingNew (withId: wingNewId) { success in
            if success {
                if let index = self.wingNews.firstIndex(where: { $0.id == wingNewId }) {
                    self.wingNews.remove(at: index)
                    print ("\(wingNewId) deleted")
                }
            }
            self.isWingNewLoading = false
        }
    }

    // function to prepare an empty content to send to the EditForm
    func createNewWingNew (_ id: String) -> WingNew {
        let newWingNew = WingNew (
            id: id,
            numero: "",
            title: "",
            url_source: "",
            photo: "",
            date: Date() )
        return newWingNew
    }
    
    func saveWingNew (_ wingNew: WingNew, completion: @escaping (Bool) -> Void) {
        isWingNewLoading = true
        DataService.shared.saveWingNew (wingNew) { [self] success in
            if success {
                print("wingNew enregistré avec succès.")
                if let index = wingNews.firstIndex(where: { $0.id == wingNew.id }) {
                    print("wingNews Index : \(index)")
                    wingNews[index] = wingNew
                }
                completion(true)
                self.isWingNewLoading = false
            } else {
                print("Erreur lors de l'enregistrement")
                completion(false)
                self.isWingNewLoading = false
            }
        }
    }

}
