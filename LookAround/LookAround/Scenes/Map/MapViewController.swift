//
//  MapViewController.swift
//  LookAround
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!

    private lazy var presenter: MapPresentable? = MapPresenter(view: self)
    private let reuseIdentifier = "MyIdentifier"
    private var annotationSelected: VenueAnnotation?

    override func viewDidLoad() {
        presenter?.searchNewVenues()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "PresentDetail",
            let venueDetail = segue.destination as? VenueDetailViewController {
            venueDetail.venueID = annotationSelected?.venueID
        }
    }
}

extension MapViewController: MapView {
    func addAnnotation(_ annotation: VenueAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func updateMap(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ myMap: MKMapView, regionDidChangeAnimated _: Bool) {
        presenter?.regionChanged(myMap.centerCoordinate)
    }

    fileprivate func create(_ annotationView: inout MKPinAnnotationView?, _ annotation: MKAnnotation) {
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.tintColor = .blue
            annotationView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView = nil
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        create(&annotationView, annotation)

        return annotationView
    }

    func mapView(_: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped _: UIControl) {
        guard let venueAnnotation = view.annotation as? VenueAnnotation else { return }
        annotationSelected = venueAnnotation
        performSegue(withIdentifier: "PresentDetail", sender: self)
    }
}
