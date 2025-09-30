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
        HStack{
            Spacer()
            // DevControlsView()
                .padding()
        }
        Spacer()
        NavigationStack(path: $path){
            Button(action: {path.append(FormType.morning)}){
                Text("Morning Reflection")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(10)
            }
            Button(action: {path.append(FormType.night)}){
                Text("Night Reflection")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(10)
            }
        }
        .navigationDestination(for: FormType.self){ form in
            JournalView(form: form, vm: EntryViewModel(form: form))
        }
        Spacer()
    }
}
