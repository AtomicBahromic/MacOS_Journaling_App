//
//  NavigationManagerView.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-18.
//

import SwiftUI
import Cocoa

enum sideBarItem: String, Identifiable, CaseIterable {
    var id: String {rawValue}
    
    case Home
    case History
    case Settings
}

struct NavigationManagerView: View{
    @State var sidebarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedSidebarItem: sideBarItem = .Home
    @StateObject private var vm = EntryViewModel()

    var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            List(sideBarItem.allCases, selection: $selectedSidebarItem) { item in
                NavigationLink(item.rawValue, value: item)
            }
        } detail: {
            switch selectedSidebarItem {
                case .Home:
                    Today().environmentObject(vm)
                case .History:
                    Text("History")
                case .Settings:
                    Text("Settings")
            }
        }
    }
}
