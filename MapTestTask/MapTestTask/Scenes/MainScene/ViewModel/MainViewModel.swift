//
//  MainViewModel.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 26.10.2023.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI

final class MainViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @Published var isLoading: Bool = false
    @Published var mapCameraPostion = MapCameraPosition
        .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.75773, longitude: -73.985708),
                                   span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    @Published var currentAddress: String = ""
    @Published var locations: [Location] = []
    @Published var pointToAdd: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    
    
    override init() {
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func addLocationButtonTapped() {
        locations.append(.init(name: currentAddress, coordinate: pointToAdd))
    }
    
    func myLocationButtonTapped() {
        locationManager.requestLocation()
    }
    
//MARK: - Получаем координаты для добавления точки
    
    func onChange(latitude: Double, longitude: Double) {
        
        pointToAdd = .init(latitude: latitude, longitude: longitude)
        
        isLoading = false
        
        geocode(latitude: latitude, longitude: longitude) { placemark, error in
          
            guard let placemark = placemark, error == nil else { return }
 

                self.currentAddress = (placemark.administrativeArea ?? "") + ", " +  (placemark.thoroughfare ?? "") + ", " + (placemark.subThoroughfare ?? "")
        }
    }
    
    private func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
}

extension MainViewModel {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationCoordinates = locations.first?.coordinate else { return }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.mapCameraPostion = MapCameraPosition
                .region(MKCoordinateRegion(center: locationCoordinates,
                                           span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                  longitudeDelta: 0.05)))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .denied, .notDetermined, .restricted:
            manager.requestAlwaysAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            guard let location = manager.location else { return  }
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            let cameraMap = MapCameraPosition.region(region)

            self.mapCameraPostion = cameraMap
            
            onChange(latitude: center.latitude, longitude: center.longitude)
      
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        manager.requestLocation()
    }
}
