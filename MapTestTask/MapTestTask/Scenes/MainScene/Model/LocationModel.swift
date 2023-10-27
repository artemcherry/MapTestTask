//
//  LocationModel.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 27.10.2023.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
