//
//  ContentView.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-15.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = EntryViewModel()
    var body: some View {
        ScrollView{
        LazyVStack {
            EntryForm()
                .environmentObject(vm)
        }
        .padding()}
    }
}

struct EntryForm: View {
    @EnvironmentObject private var vm: EntryViewModel
    
    var body: some View {
        ValuesEntry(cues:vm.valueCues, statements: $vm.valueStatements)
        
        GoalInputs(statements: $vm.supportive)
        
        AvoidanceEntries(statements: $vm.obstructive)
        
        Predictions(cues: vm.predictionCues, statements: $vm.BestWorstLikely)
        
        Reasons(statements: $vm.reasons)
        
        Button("Save") { vm.saveEntry()}
            .padding(30)
    }
}


    


#Preview {
    ContentView()
}
