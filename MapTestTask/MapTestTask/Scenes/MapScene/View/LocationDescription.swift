//
//  LocationDescription.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 26.10.2023.
//

import SwiftUI

struct LocationDescriptionView: View {
    
   @Binding var isLoading: Bool
    var address: String
    
    var body: some View {
        
        VStack {
            
            if isLoading {
                
                ProgressView()
                
            } else {
                
                Text(address)
            }
        }
        .frame(width: 300)
        .background(.black.opacity(0.3))
        .cornerRadius(25)
        .animation(.linear, value: isLoading)
    }
}
