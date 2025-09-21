//
//  NavigationManagerView.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-18.
//

import SwiftUI

enum sideBarItem: String, Identifiable, CaseIterable {
    var id: String {rawValue}
    
    case Journal
    case Calendar
    case Meditation
}

struct ContentView: View{
    @State var sidebarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedSidebarItem: sideBarItem = .Journal

    var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            List(sideBarItem.allCases, selection: $selectedSidebarItem) { item in
                
                    
                NavigationLink(value: item) {
                    HStack {
                        switch item {
                        case .Journal:
                            Image(systemName: "square.and.pencil")
                        case .Calendar:
                            Image(systemName: "calendar")
                        case .Meditation:
                            Image(systemName: "figure.mind.and.body")
                        }
                        Text(item.rawValue)
                    }
                }
            }
        } detail: {
            switch selectedSidebarItem{
                case .Journal:
                    JournalViews()
                case .Calendar:
                    Text("Calendar")
                case .Meditation:
                    Text("Meditations")
            }
        }
    }
}
