//
//  HistoryViewModel.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-09-30.
//


import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var formsCompleted: [Form] = []
    
    init(){
        do {
            formsCompleted = try DataController.shared.fetchAllForms()
        } catch {
            return
        }
    }
    
    func returnEntries() -> [Entry] {
        return []
    }
    
}
