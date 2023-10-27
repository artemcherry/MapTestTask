//
//  MapView.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 26.10.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        
        ZStack {

            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Image(.userPointer)
                        .foregroundColor(.pink)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 1,
                            coordinateSpace: .global)
                .onChanged { _ in
                    
                    viewModel.isLoading.toggle()
            })
            .ignoresSafeArea(edges: .top)
            
            VStack {
                
                Image(.userPointer)
                    .foregroundColor(.cyan)
                    .padding(.bottom, 10)
                
                LocationDescriptionView(isLoading: $viewModel.isLoading, address: viewModel.currentAddress)
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
            .onChange(of: viewModel.isLoading) { newValue in
                if !newValue {
                    viewModel.onChange()
                }
            }
        }
    }
}

#Preview {
    MapView(viewModel: .init())
}
