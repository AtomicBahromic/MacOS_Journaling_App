//
//  EntryViews.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-16.
//
import SwiftUI

struct Title: View {
    var body: some View {
        Text("Haoma Journal")
            .font(.system(size: 36, weight: .bold))
            .foregroundColor(.white)
    }
}

struct Streak: View {
    let vm: EntryViewModel
    var body: some View {
        let streak = vm.streak
        
        VStack {
            Text("STREAK")
                .font(.caption)
                .foregroundColor(.white)
            ZStack{
                Circle()
                    .stroke(
                            vm.isDone ? Color.red : Color.white,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                    .frame(width: 70, height: 70)
                    .opacity(0.25)
                Text("\(streak)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }.padding(5)
        }.padding(15)
    }
}


struct ValuesEntry: View {
    let cues: [String]
    @Binding var statements: [String]
    
    var body: some View {
        ForEach(0..<4) { i in
            TextField(cues[i], text: $statements[i]).padding(10)
                .journalStyle()
        }
    }
}

struct GoalInputs: View {
    @Binding var statements: [String]
    var body: some View {
        VStack{
            VStack{
                Text("What is my primary goal for today?")
                TextField("e.g. I wanna enrol into my university courses at 2pm", text: $statements[0])
                    .journalStyle()
            }.padding(20)
            
            Text("Why does it help me?")
            ForEach(0..<3) { i in
                TextField("\(i+1)", text: $statements[i+1])
                    .journalStyle()
            }.padding(2)
        }.padding(10)
    }
}

struct AvoidanceEntries: View {
    @Binding var statements: [String]
    var body: some View {
        VStack{
                VStack{
                    Text("What is the one behaviour I wanna avoid today?")
                    TextField("e.g. I don't wanna check the news today", text: $statements[0])
                        .journalStyle()
                }.padding(20)
                
                Text("Why does the behaviour hurt me?")
                ForEach(0..<3) { i in
                    TextField("\(i+1)", text: $statements[i+1])
                        .journalStyle()
                }.padding(2)
        }.padding(30)
    }
}

struct Predictions: View {
    let cues: [String]
    @Binding var statements: [String]
    
    var body: some View {
        Text("Predict the different ways this day could play out.")
        ForEach(0..<3) { i in
            TextField(cues[i], text: $statements[i])
                .journalStyle()
        }
    }
}

struct Reasons: View{
    @Binding var statements: [String]
    
    var body: some View{
        VStack{
            Section("What are three reasons I can succeed today?") {
                ForEach(0..<3) { i in
                    TextField("\(i+1)", text: $statements[i])
                        .journalStyle()
                }.padding(2)
            }
            // … repeat for obstructive, mood slider, etc.

        } .padding(30)
    }
}

extension View {
    func journalStyle() -> some View {
        self.padding()
            .textFieldStyle(.roundedBorder)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(.secondary.opacity(0.3))
            .disabled(!DataController.shared.todayEntries.isEmpty)
            .cornerRadius(10)
    }
}

