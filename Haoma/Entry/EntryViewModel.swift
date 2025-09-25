//
//  EntryViewModel.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-16.
//

import Foundation

class EntryViewModel: ObservableObject {
    
    @Published var statements = Array(repeating: "", count: JournalForms.morning.entries.count)
    @Published var isDone = !DataController.shared.todayEntries.isEmpty
    
    func saveEntry(){
        do {
            try DataController.shared.createForm(formType: "daily")
        }
        catch {
            print("failed to insert form")
            return
        }
        // 2) save each prompt response with that formId (or nil if creation failed)
        
        let formId = (try? DataController.shared.latestForm()?.id ?? 1) ?? -1
        
        for i in 0..<self.statements.count {
            DataController.shared.enter(cue: JournalForms.morning.entries[i], statement: statements[i], formId: Int64(formId))
        }
        print(formId)
        self.isDone = true
    }
    
    func deleteEntries(){
        do {
            try DataController.shared.deleteEntries(on: Date())
        } catch {
            print("error deleting entries")
        }
        self.isDone = false
        statements = Array(repeating: "", count: JournalForms.morning.entries.count)
    }
    
    var isFilled: Bool{!self.statements.contains("")}
    
    
    var streak: Int{
        // Start with 1 if there’s an entry today, otherwise 0
        var count = 0
        let entries = DataController.shared.allEntries
        let calendar = Calendar.current

        // Keep going back one more day for each count,
        // and stop once there’s no entry on that day.
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
