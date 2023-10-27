//
//  MapView.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 26.10.2023.
//

import SwiftUI
import MapKit

struct MapView: View {

    @ObservedObject var viewModel: MainViewModel
           
    var body: some View {
        
        ZStack {
            
            Map(position: $viewModel.mapCameraPostion) {
                ForEach(viewModel.locations) { location in
                    Annotation("", coordinate: location.coordinate) {
                        Image(.userPointer)
                            .foregroundColor(.pink)
                    }
                }
            }
            .onMapCameraChange(frequency: .onEnd) { mapCameraUpdateContext in
                
                viewModel.onChange(latitude: mapCameraUpdateContext.camera.centerCoordinate.latitude,
                                   longitude: mapCameraUpdateContext.camera.centerCoordinate.longitude)
            }
            .onMapCameraChange(frequency: .continuous) { _ in
                
                viewModel.isLoading = true
            }

            VStack {
                
                Image(.userPointer)
                    .foregroundColor(.cyan)
                    .padding(.bottom, 10)
                
                LocationDescriptionView(isLoading: viewModel.isLoading, address: viewModel.currentAddress)
            }
            
            VStack {
                
                HStack {
                    
                    Button {
                        
                        viewModel.addLocationButtonTapped()
                    } label: {
                        
                        Text("Add to my locations")
                            .foregroundColor(.white)
                            .padding()
                            .background {
                                
                                Rectangle()
                                    .fill(.black)
                                    .cornerRadius(15)
                            }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        
                        viewModel.myLocationButtonTapped()
                    } label: {
                        
                        ZStack {
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 44, height: 44)
                            
                            Image(.arrowIcon)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
}
