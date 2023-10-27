//
//  LocationsView.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 27.10.2023.
//

import SwiftUI

struct LocationsView: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        
        NavigationView {
            
            List(viewModel.locations, rowContent: { location in
                
                Text(location.name)
            })
            .navigationTitle("Locations")
        }
    }
}
