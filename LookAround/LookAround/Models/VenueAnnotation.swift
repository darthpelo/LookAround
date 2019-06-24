//
//  VenueAnnotation.swift
//  LookAround
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import MapKit

class VenueAnnotation: NSObject, MKAnnotation {
    let venueID: String
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(venueID: String, title: String?, coordinate: CLLocationCoordinate2D) {
        self.venueID = venueID
        self.title = title
        self.coordinate = coordinate

        super.init()
    }
}
