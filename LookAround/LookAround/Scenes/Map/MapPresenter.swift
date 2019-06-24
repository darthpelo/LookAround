//
//  MapPresenter.swift
//  LookAround
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import Foundation
import MapKit

protocol MapPresentable {
    func regionChanged(_ center: CLLocationCoordinate2D)
    func searchNewVenues()
}

protocol MapView {
    func updateMap(region: MKCoordinateRegion)
    func addAnnotation(_ annotation: VenueAnnotation)
}

final class MapPresenter: NSObject, MapPresentable {
    typealias Dependencies = HasFoursquareClientable

    private var locationManager: CLLocationManager?
    private var dependencies: Dependencies?
    private var view: MapView?
    private let distanceSpan: Double = 500
    private var lastUserPosition: CLLocationCoordinate2D?
    private var venues: [Venue] = []

    init(view: MapView, dependencies: Dependencies = AppDependencies()) {
        self.view = view
        self.dependencies = dependencies

        super.init()

        locationManagerInit()
    }

    func regionChanged(_ center: CLLocationCoordinate2D) {
        let parameter: [String: String] = [
            "ll": "\(center.latitude),\(center.longitude)",
            "intent": "browse",
            "radius": "\(distanceSpan)",
        ]

        getVenues(parameter)
    }

    func searchNewVenues() {
        if let coordinate = lastUserPosition {
            let parameter: [String: String] = [
                "ll": "\(coordinate.latitude),\(coordinate.longitude)",
                "intent": "browse",
                "radius": "\(distanceSpan)",
            ]

            getVenues(parameter)
        }
    }

    // MARK: - Private

    private func addAnnotations() {
        if venues.isEmpty == false {
            venues.forEach { venue in
                let annotation = VenueAnnotation(venueID: venue.venueId,
                                                 title: venue.name,
                                                 coordinate: CLLocationCoordinate2D(latitude: venue.location.latitude,
                                                                                    longitude: venue.location.longitude))

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.view?.addAnnotation(annotation)
                }
            }
        }
    }

    private func getVenues(_ parameter: [String: String]) {
        dependencies?.foursquareClientable.getVenues(parameter: parameter,
                                                     completion: { [weak self] result in
                                                         guard let self = self else { return }

                                                         if let result = result {
                                                             self.venues.removeAll()
                                                             self.venues.append(contentsOf: result)
                                                             self.addAnnotations()
                                                         } else {
                                                             print("search error")
                                                         }
        })
    }

    private func locationManagerInit() {
        locationManager = CLLocationManager()

        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50 // Don't send location updates with a distance smaller than 50 meters between them
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
}

extension MapPresenter: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager!.startUpdatingLocation()
        default:
            locationManager!.stopUpdatingLocation()
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lastUserPosition = location.coordinate
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: distanceSpan,
                                            longitudinalMeters: distanceSpan)
            view?.updateMap(region: region)
            searchNewVenues()
        }
    }
}
