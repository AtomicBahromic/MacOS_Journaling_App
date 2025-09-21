//
//  EntryViewModel.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-16.
//

import Foundation

class EntryViewModel: ObservableObject {
    let valueCues = ["What matters to you in this world?", "What is your duty on this planet?", "What would your ideal life look like?"]
    let objectiveCues = ["What is my primary goal for today?", "Helpful Reason #1", "Helpful Reason #2", "Helpful Reason #3"]
    let strategyCue = ["What's one thing I can do right now to affect the day?", "What is ONE effect of that action?"]
    
    @Published var valueStatements = ["","",""]
    @Published var supportive = ["","",""]
    @Published var strategies = ["", ""]
    @Published var isDone = !DataController.shared.todayEntries.isEmpty
    
    init() {
        if (self.isDone) {
            let entries = loadEntry()
            valueStatements = entries[0]
            supportive = entries[1]
            strategies = entries[2]
        }
    }
    
    func loadEntry() -> [[String]]{
        let entries = DataController.shared.todayEntries
        let valuesStatements = entries.prefix(3).map(\.Statement)
        let supportive = entries[3..<7].map(\.Statement)
        let strategies = [entries[6].Statement, entries[7].Statement]
        return [valuesStatements, supportive, strategies]
    }
    
    func saveEntry(){
        let inputs = [valueStatements, supportive, strategies]
        let cues = [valueCues, objectiveCues, strategies]
        
        for i in 0..<inputs.count{
            for j in 0..<inputs[i].count{
                DataController.shared.enter(cue: cues[i][j], statement: inputs[i][j])
            }
        }
        self.isDone = true
    }
    
    func deleteEntries(){
        do {
            try DataController.shared.deleteEntries(on: Date())
        } catch {
            print("error deleting entries")
        }
        self.isDone = false
        valueStatements = ["","",""]
        supportive = ["","",""]
        strategies = ["", ""]
    }
    
    var isFilled: Bool{
        let inputs = [valueStatements, supportive, strategies]
        for inputType in inputs{
            if inputType.contains(where: {$0.isEmpty}){
                return false
            }
        }
        return true
    }
    
    
    
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
