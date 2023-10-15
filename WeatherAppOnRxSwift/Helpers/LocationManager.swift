//
//  LocationManager.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 07.10.2023.
//

import Foundation
import CoreLocation
import RxSwift

private extension Int {
    static let MoscowLatitude = 55.7558
    static let MoscowLongitude = 37.6176
}

private extension String {
    static let identifier = "en_GB"
}

protocol ILocationManager {
    var locationAuthorizationStatus: PublishSubject<CLAuthorizationStatus> { get }
    func cityWhereUserIsLocated() -> Observable<String> 
}

class LocationManager: NSObject, ILocationManager {
    
    var locationAuthorizationStatus = PublishSubject<CLAuthorizationStatus>()
    
    private var locationManager = CLLocationManager()
    private let locale = Locale(identifier: .identifier)
    
    //    MARK: - init
    
    override init() {
        super.init()
        geolocationTrackingRequest()
    }
    
    //    MARK: - search for the city by the coordinates in which the user is located
    
    func cityWhereUserIsLocated() -> Observable<String> {
        let geocoder = CLGeocoder()
        let location = self.provideCoordinatesOfCurrentLocationOtherwiseMoscow()
        return Observable.create { observer in
            geocoder.reverseGeocodeLocation(location, preferredLocale: self.locale) { placemarks, error in
                if let error {
                    observer.onError(error)
                } else if let placemark = placemarks?.first,
                          let locality = placemark.locality {
                    observer.onNext(locality)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - private methods

private extension LocationManager {
    
    //    MARK: - request for location tracking
    
    func geolocationTrackingRequest() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    //    MARK: - provide the user's current location, otherwise Moscow
    
    func provideCoordinatesOfCurrentLocationOtherwiseMoscow() -> CLLocation {
        if let location = self.locationManager.location {
            return location
        } else {
            return CLLocation(latitude: Int.MoscowLatitude, longitude: Int.MoscowLongitude)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationAuthorizationStatus.onNext(manager.authorizationStatus)
    }
}
