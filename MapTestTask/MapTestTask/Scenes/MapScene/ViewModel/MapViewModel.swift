//
//  MapViewModel.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 26.10.2023.
//

import Foundation
import MapKit
import CoreLocation

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @Published var isLoading: Bool = false
    @Published var currentAddress: String = ""
    @Published var locations: [Location] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.75773, longitude: -73.985708), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    override init() {
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func addLocationButtonTapped() {
        locations.append(.init(name: "pin", coordinate: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)))
    }
    
    func myLocationButtonTapped() {
        locationManager.requestLocation()
    }
    
    func onChange() {
       
        geocode(latitude: region.center.latitude, longitude: region.center.longitude) { placemark, error in
          
            guard let placemark = placemark, error == nil else { return }
 
            DispatchQueue.main.async {

                self.currentAddress = (placemark.administrativeArea ?? "") + ", " +  (placemark.thoroughfare ?? "") + ", " + (placemark.subThoroughfare ?? "")
            }
        }
    }
    
    private func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
}

extension MapViewModel {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationCoordinates = locations.first?.coordinate else { return }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.region = .init(center: locationCoordinates,
                                span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                       longitudeDelta: 0.05))
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
         
            DispatchQueue.main.async { [weak self] in
                
                guard let self else { return }
                
                self.region = region
            }
            onChange()
            
        @unknown default:
            print("not location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        manager.requestLocation()
    }
}
