//
//  EntrySelectionView.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-09-30.
//

import SwiftUI


struct EntrySelectionView: View {
    @State var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path){
            HStack{
                DevControlsView()
                Spacer()
                    .padding()
                Button(action:{path.append(EntryRoutes.history)}) {
                    HStack{
                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        Text("History")
                    }
                }
                .padding()
            }
            Spacer()
            Button(action: {path.append(EntryRoutes.forms(.morning))}){
                Text("Morning Reflection")
                    .frame(width: 300, height: 50)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(10)
            }
            Button(action: {path.append(EntryRoutes.forms(.night))}){
                Text("Night Reflection")
                    .frame(width: 300, height: 50)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .navigationDestination(for: EntryRoutes.self){ route in
            switch route {
            case .forms(let formType): JournalView(form: formType, vm: EntryViewModel(form: formType))
            case .history: HistoryView()
            default: Text("some other view")
            }
        }
    }
}


// Optional notification so view models can reload after a wipe
extension Notification.Name {
    static let devDatabaseWiped = Notification.Name("devDatabaseWiped")
}

struct DevControlsView: View {
    @State private var showingConfirm = false
    @State private var showingResult = false
    @State private var resultMessage = ""
    
    var body: some View {
#if DEBUG
        VStack {
            Button(role: .destructive) {
                showingConfirm = true
            } label: {
                Label("Wipe DB (dev only)", systemImage: "trash.circle")
            }
            .buttonStyle(.bordered)
            .tint(.red)
            .confirmationDialog("Delete local database? This will permanently remove all local data.", isPresented: $showingConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    performWipe()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .alert(resultMessage, isPresented: $showingResult) {
            Button("OK", role: .cancel) { }
        }
#else
        EmptyView()
#endif
    }
    
    private func performWipe() {
        do {
            try DataController.shared.wipeDatabaseForDevelopment()
            // notify app so VMs can reload caches
            NotificationCenter.default.post(name: .devDatabaseWiped, object: nil)
            resultMessage = "Database wiped and recreated."
        } catch {
            resultMessage = "Wipe failed: \(error.localizedDescription)"
        }
        showingResult = true
    }
}
