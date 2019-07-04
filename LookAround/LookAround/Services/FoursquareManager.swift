//
//  FoursquareManager.swift
//  LookAround
//
//  Created by Alessio Roberto on 24/06/2019.
//  Copyright © 2019 Alessio Roberto. All rights reserved.
//

import Foundation

import FoursquareAPIClient

protocol HasFoursquareClientable {
    var foursquareClientable: FoursquareClientable { get }
}

protocol FoursquareClientable {
    func getVenues(parameter: [String: String], completion: @escaping ([Venue]?) -> Void)
    func getDetail(venueID: String, completion: @escaping (VenueDetail?) -> Void)
}

enum Query {
    case search
    case detail
}

struct FoursquareManager: FoursquareClientable {
    private var apiClient: FoursquareAPIClient?
    private let getVenuesPath = "venues/search"
    
    init() {
        apiClient = FoursquareAPIClient(clientId: "",
                                        clientSecret: "")
    }

    func getVenues(parameter: [String: String], completion: @escaping ([Venue]?) -> Void) {
        apiClient?.request(path: getVenuesPath, parameter: parameter) { result in
            switch result {
            case let .success(data):
                self.decodeResponse(data, .search, completion: { reponse in
                    let resp = reponse as? Response<SearchResponse>
                    completion(resp?.response.venues)
                })
            case let .failure(error):
                self.errorHandler(error)

                completion(nil)
            }
        }
    }

    func getDetail(venueID: String, completion: @escaping (VenueDetail?) -> Void) {
        apiClient?.request(path: "venues/\(venueID)", parameter: [:], completion: { result in
            switch result {
            case let .success(data):
                self.decodeResponse(data, .detail, completion: { reponse in
                    let resp = reponse as? Response<DetailResponse>
                    completion(resp?.response.venue)
                })
            case let .failure(error):
                self.errorHandler(error)

                completion(nil)
            }
        })
    }

    private func decodeResponse(_ data: Data, _ query: Query, completion: (Any?) -> Void) {
        let decoder: JSONDecoder = JSONDecoder()
        do {
            if query == .search {
                let response = try decoder.decode(Response<SearchResponse>.self,
                                                  from: data)
                            completion(response)
            } else {
                let response = try decoder.decode(Response<DetailResponse>.self, from: data)
                completion(response)
            }

        } catch {
            completion(nil)
        }
    }

    private func errorHandler(_ error: FoursquareClientError) {
        switch error {
        case let .connectionError(connectionError):
            print(connectionError)
        case let .responseParseError(responseParseError):
            print(responseParseError) // e.g. JSON text did not start with array or object and option to allow fragments not set.
        case let .apiError(apiError):
            print(apiError.errorType) // e.g. endpoint_error
            print(apiError.errorDetail) // e.g. The requested path does not exist.
        }
    }
}
