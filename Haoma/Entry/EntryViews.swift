//
//  EntryViews.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-16.
//
import SwiftUI

struct JournalViews: View {
    @State var path = NavigationPath()
    @StateObject var vm = EntryViewModel()
    
    var body: some View {
        
        HStack{
            Spacer()
            DevControlsView()
                .padding()
        }
        Spacer()
        NavigationStack(path: $path){
            Button(action: {path.append(JournalForms.morning)}){
                Text("Morning Reflection")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(10)
            }
        }
        .navigationDestination(for: JournalForms.self){ form in
            switch form {
            case JournalForms.morning: Today().environmentObject(vm)
                
                case JournalForms.night:
                    Text("Night")
                
            }
        }
        Spacer()
    }
}

struct Today: View {
    @EnvironmentObject var vm: EntryViewModel
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
            
            Text("Morning Reflection")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .padding()
            vm.isDone ? Text("Done For Today! 🎉").font(.title) : Text("")
            Streak()
                .environmentObject(vm)
            EntryForm()
                .environmentObject(vm)
                .disabled(vm.isDone)
            
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

struct EntryForm: View {
    @EnvironmentObject var vm: EntryViewModel
    
    var body: some View {
        
        JournalEntries(cues: JournalForms.morning.entries, statements: $vm.statements)
            .padding(.vertical, 10)
        
        Button("Save") { vm.saveEntry()}
            .padding(30)
            .disabled(!vm.isFilled)
    }
}

struct DevControlsView: View {
    @State private var showingConfirm = false
    var body: some View {
#if DEBUG
        HStack{
            
            Button("Wipe DB (dev only)") { showingConfirm = true }
                .foregroundColor(.red)
                .alert("Delete database?", isPresented: $showingConfirm) {
                    Button("Delete", role: .destructive) {
                        do {
                            try DataController.shared.wipeDatabaseForDevelopment()
                            print("DB wiped")
                        } catch {
                            print("Wipe failed:", error)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will permanently delete all local data. Only for development.")
                }
            Button("Print DB") {
                let entries = DataController.shared.allEntries
                for entry in entries {
                    print("ID: \(entry.id ?? 0) , Date:\(entry.date), FormID:\(entry.formId ?? 0)")
                }
            }
        }
        
#else
        EmptyView()
#endif
    }
}
