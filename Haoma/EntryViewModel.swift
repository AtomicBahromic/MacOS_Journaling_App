//
//  EntryViewModel.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-16.
//

import Foundation

class EntryViewModel: ObservableObject {
    let valueCues = ["What is the one thing I wanna accomplish in life?", "What kind of life do I wanna live?", "What kind of body do I want?", "What kind of mind do I want?"]
    let objectiveCues = ["What is my primary objective for today?", "Helpful Reason #1", "Helpful Reason #2", "Helpful Reason #3"]
    let avoidanceCues = ["What is the one thing I avoid doing?", "Reason #1", "Reason #2", "Reason #3"]
    let predictionCues = ["Best Case", "Worst Case", "Most Likely"]
    let reasonsCues = ["Reason for Success #1", "Reason for Success #2", "Reason for Success #3"]
    
    @Published var valueStatements = ["","","",""]
    @Published var supportive = ["","","",""]
    @Published var obstructive = ["", "","",""]
    @Published var BestWorstLikely = ["","",""]
    @Published var reasons = ["","",""]
    
    func saveEntry(){
        var inputs = [valueStatements, supportive, obstructive, BestWorstLikely, reasons]
        let cues = [valueCues, objectiveCues, avoidanceCues, predictionCues, reasonsCues]
        
        for i in 0..<inputs.count{
            for j in 0..<inputs[i].count{
                DataController.shared.enter(cue: cues[i][j], statement: inputs[i][j])
                inputs[i][j] = ""
            }
        }
    }
}
