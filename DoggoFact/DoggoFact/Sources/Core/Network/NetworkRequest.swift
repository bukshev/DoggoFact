//
//  NetworkRequest.swift
//  DoggoFact
//
//  Created by Иван Букшев on 14.11.2021.
//

import Foundation

struct NetworkRequest {
    let endpoint: API.Endpoint
    let queryItems: [URLQueryItem]
}
