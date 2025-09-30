//
//  HistoryView.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-09-30.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var vm = HistoryViewModel()
    
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            VStack {
                ForEach(vm.formsCompleted, id: \.self.id) {form in
                    PastEntryView(id: form.id ?? -1)
                }
            }
            Spacer()
        }
        Spacer()
    }
}

struct PastEntryView: View {
    let id: Int64
    var body: some View {
        Text("\(id)")
    }
}
