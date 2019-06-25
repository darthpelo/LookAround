//
//  VenueDetail.swift
//  LookAround
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import Foundation

struct VenueDetail: Codable {
    let venueId: String
    let name: String
    let location: Location

    private enum CodingKeys: String, CodingKey {
        case venueId = "id"
        case name
        case location
    }
}
