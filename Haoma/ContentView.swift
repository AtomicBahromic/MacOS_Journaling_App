//
//  ContentView.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            EntryForm()
        }
        .padding()
    }
}

struct EntryForm: View {
  @State var valueStatement = ""
  @State var bodyStatement = ""
  @State var reasons = ["","",""]
  @State var supportive = ["","",""]
  @State var obstructive = ["","",""]
  @State var mood = 5
  // …
  var body: some View {
    Form {
      Section("Value for Today") {
        TextField("What life do I want?", text: $valueStatement)
        TextField("What body do I want?", text: $bodyStatement)
      }.padding(10)
      Section("Supportive Behaviors") {
        ForEach(0..<3) { i in
          TextField("\(i+1)", text: $supportive[i])
        }.padding(2)
      }
      Section("Obstructive Behaviours") {
        ForEach(0..<3) { i in
            TextField("\(i+1)", text: $obstructive[i])
        }.padding(2)
      }
        Section("What are three reasons you can succeed today?") {
          ForEach(0..<3) { i in
              TextField("\(i+1)", text: $reasons[i])
          }.padding(2)
        }
      // … repeat for obstructive, mood slider, etc.
        Button("Save") { saveEntry()}.padding(30)
    }
  }
}

func saveEntry() {
    
}

#Preview {
    ContentView()
}
