//
//  JournalView.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-09-30.
//

//
//  TodayForm.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-09-30.
//
import SwiftUI

struct JournalView: View {
    let form: FormType
    @StateObject var vm: EntryViewModel
    
    var body: some View {
        ScrollView{
            LazyVStack {
                HStack{
                    Spacer()
#if DEBUG
                    Button("Delete Entries") {
                        vm.deleteEntries()
                    }
#endif
                }
                
                Text(form.name + " Reflection")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                vm.isDone ? Text("Done For Today! 🎉").font(.title) : Text("")
                Streak()
                    .environmentObject(vm)
                JournalEntries(cues: vm.form.entries, statements: $vm.statements)
                    .padding(.vertical, 10)
                Button("Save") { vm.saveEntry()}
                    .padding(30)
                    .disabled(!vm.isFilled)
                
            }
            .padding()}
    }
}



struct Streak: View {
    @EnvironmentObject var vm: EntryViewModel
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
        }.padding(10)
    }
}

struct JournalEntries: View {
    let cues: [String]
    @Binding var statements: [String]
    
    var body: some View {
        ForEach(cues.indices, id: \.self) { i in
            VStack{
                Text(cues[i])
                    .padding(4)
                TextField("", text: $statements[i])
                    .journalStyle()
            }
        }
    }
}

extension View {
    func journalStyle() -> some View {
        self.padding()
            .textFieldStyle(.roundedBorder)
            .frame(maxWidth: 800, maxHeight: 40)
            .background(.secondary.opacity(0.3))
            .cornerRadius(10)
    }
}

