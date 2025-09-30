//
//  EntryViewModel.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-16.
//

import Foundation

@MainActor
final class EntryViewModel: ObservableObject {
    let form: FormType
    
    @Published var statements: [String] = []
    @Published var isDone = !DataController.shared.todayEntries.isEmpty
    
    
    init(form: FormType){
        self.form = form
        statements = Array(repeating: "", count: self.form.entries.count)
    }
    
    
    func saveEntry(){
        do {
            try DataController.shared.createForm(formType: form.name) // make formType dynamic
        }
        catch {
            print("failed to insert form")
            return
        }
        
        let formId = (try? DataController.shared.latestForm()?.id ?? 1) ?? -1
        
        for i in 0..<self.form.entries.count {
            DataController.shared.enter(cue: self.form.entries[i], statement: statements[i], formId: Int64(formId))
        }
        print(formId)
        self.isDone = true
        statements = Array(repeating: "", count: self.form.entries.count)
    }
    
    func deleteEntries(){
        do {
            try DataController.shared.deleteEntries(on: Date())
        } catch {
            print("error deleting entries")
        }
        self.isDone = false
        statements = Array(repeating: "", count: self.form.entries.count)
    }
    
    var isFilled: Bool{!self.statements.contains("")}
    
    
    var streak: Int{
        var count = 0
        let entries = DataController.shared.allEntries
        let calendar = Calendar.current

        while entries.contains(where: {
            calendar.isDate(
                $0.date,
                inSameDayAs: calendar.date(byAdding: .day,
                                           value: -(count + 1),
                                           to: Date())!
            )
        }) {
            count += 1
        }
        
        count += DataController.shared.todayEntries.isEmpty ? 0 : 1

        return count
    }
}


enum Route: Hashable {
    case today, history, settings
}
