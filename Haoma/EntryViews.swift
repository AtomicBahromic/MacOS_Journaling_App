//
//  EntryViews.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-16.
//
import SwiftUI

struct ValuesEntry: View {
    let cues: [String]
    @Binding var statements: [String]
    
    var body: some View {
        Form{
            ForEach(0..<4) { i in
                TextField(cues[i], text: $statements[i]).padding(10)
            }
        }
    }
}

struct GoalInputs: View {
    @Binding var statements: [String]
    var body: some View {
        VStack{
            Section("Primary Objective"){
                VStack{
                    Text("What is my primary objective for today?")
                    TextField("e.g. I wanna enrol into my university courses at 2pm", text: $statements[0])
                }.padding(20)
                
                Text("How does the objective help me?")
                ForEach(0..<3) { i in
                    TextField("\(i+1)", text: $statements[i+1])
                }.padding(2)
            }
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
                }.padding(20)
                
                Text("Why does the behaviour hurt me?")
                ForEach(0..<3) { i in
                    TextField("\(i+1)", text: $statements[i+1])
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
                }.padding(2)
            }
            // … repeat for obstructive, mood slider, etc.

        } .padding(30)
    }
}


