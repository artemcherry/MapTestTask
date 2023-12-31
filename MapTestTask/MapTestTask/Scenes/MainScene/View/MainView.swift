//
//  MainView.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 26.10.2023.
//

import SwiftUI

struct MainView: View {
  
    @ObservedObject var viewModel: MainViewModel
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapView(viewModel: viewModel)
                .tabItem {
                    
                    VStack {
                        Image(systemName: "globe")
                        Text("Map")
                    }
                }
            
            LocationsView(viewModel: viewModel)
                .tabItem {
                    
                    VStack {
                        Image(systemName: "mappin")
                        Text("Locations")
                    }
                }
        }
    }
}
