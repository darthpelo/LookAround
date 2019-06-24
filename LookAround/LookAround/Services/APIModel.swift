//
//  APIModel.swift
//  LookAround
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

struct Response<Response: Codable>: Codable {
    let response: Response
}

struct SearchResponse: Codable {
    let venues: [Venue]
}
