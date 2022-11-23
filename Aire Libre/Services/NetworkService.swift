//
//  NetworkService.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-22.
//

import Foundation

/// Abstracts calls to the network to retrieve data from Aire Libre's API
protocol NetworkService {
    /// Fetches AQI data from network
    ///
    /// Fetches Air Quality Index data according to the parameters
    ///
    /// - Parameter source: Include measurements from this source only
    /// - Parameter start: Include measurements after this date and time
    /// - Parameter end: Include measurements before this date and time
    /// - Parameter latitude: Target latitude coordinate
    /// - Parameter longitude: Target longitude coordinate
    /// - Parameter distance: Include measurements that are this kilometers far from the target
    /// - Parameter handler: Function called with the result of the network call
    func fetchAQI(
        start: Date?,
        end: Date?,
        latitude: Double?,
        longitude: Double?,
        distance: Double?,
        source: String?,
        handler: @escaping ((Result<[AQIData], AppError>) -> Void)
    )
}

/// Concrete implementation of ``NetworkService``
final class NetworkServiceImpl: NetworkService {
    private let endpoints: NetworkServiceEndpoints
    
    init(endpoints: NetworkServiceEndpoints) {
        self.endpoints = endpoints
    }
    
    func fetchAQI(
        start: Date? = nil,
        end: Date? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        distance: Double? = nil,
        source: String? = nil,
        handler: @escaping ((Result<[AQIData], AppError>) -> Void)
    ) {
        guard var urlComponents = URLComponents(url: endpoints.aqiEndpoint,
                                                resolvingAgainstBaseURL: true) else {
            handler(.failure(.invalidEndpoindURL))
            return
        }
        
        // Create a dictionary for query params
        let queryParams: [String: String?] = [
            "start": start?.formatted(.iso8601),
            "end": end?.formatted(.iso8601),
            "latitude": latitude?.formatted(.number),
            "longitude": longitude?.formatted(.number),
            "distance": distance?.formatted(.number),
            "source": source
        ]
        
        // Translate dictionary to actual URLQueryItems ignoring nil values
        // in the dictionary
        urlComponents.queryItems = queryParams.compactMap({ (key: String, value: String?) in
            guard let value else {
                return nil
            }
            
            return URLQueryItem(name: key, value: value)
        })

        // Get the full url from components
        guard let requestURL = urlComponents.url else {
            handler(.failure(.invalidEndpoindURL))
            return
        }

        var request = URLRequest(url: requestURL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        // perform the request
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                // according to apple's documentation if data == nil
                // then error != nil
                handler(.failure(.networkError(cause: error!)))
                return
            }
            
            // parse the response
            let decoder = JSONDecoder()
            
            do {
                // decode the json response
                let characters = try decoder.decode([AQIData].self, from: data)
                handler(.success(characters))
            } catch let error {
                handler(.failure(.networkError(cause: error)))
            }
        }.resume()
    }
}
