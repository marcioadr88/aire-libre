//
//  NetworkService.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-22.
//

import Foundation
import OSLog

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
    func fetchAQI(
        start: Date?,
        end: Date?,
        latitude: Double?,
        longitude: Double?,
        distance: Double?,
        source: String?) async throws -> [AQIData]
}

/// Concrete implementation of ``NetworkService``
final class NetworkServiceImpl: NetworkService {
    private let log = Logger(subsystem: "repository.re.airelib.ios",
                             category: "NetworkServiceImpl")
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
        source: String? = nil
    ) async throws -> [AQIData] {
        let request = try buildGetAQIDataURLRequest(start: start,
                                                    end: end,
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                    distance: distance,
                                                    source: source)
        do {
            log.debug("Requesting AQI data")
            // perform the request, ignore returned URLResponse
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // parse the response
            let decoder = JSONDecoder()
            
            do {
                log.debug("Decoding response")
                // decode the json response
                let aqiData = try decoder.decode([AQIData].self, from: data)
                
                log.info("Returning \(aqiData.count) aqi data results")
                return aqiData
            } catch let error {
                log.error("Error decoding AQI data response: \(error.localizedDescription)")
                throw AppError.decodingError(cause: error)
            }
        } catch let error {
            log.error("Error requesting AQI data: \(error.localizedDescription)")
            throw AppError.networkError(cause: error)
        }
    }
    
    
    private func buildGetAQIDataURLRequest(
        start: Date? = nil,
        end: Date? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        distance: Double? = nil,
        source: String? = nil) throws -> URLRequest {
            guard var urlComponents = URLComponents(url: endpoints.aqiEndpoint,
                                                    resolvingAgainstBaseURL: true) else {
                log.error("Cannot create URLComponents from endpoint")
                throw AppError.invalidEndpoindURL
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
            
            log.debug("Using params \(queryParams)")
            
            // Translate dictionary to actual URLQueryItems ignoring nil values
            // in the dictionary
            urlComponents.queryItems = queryParams
                .compactMap({ (key: String, value: String?) in
                    guard let value else {
                        return nil
                    }
                    
                    return URLQueryItem(name: key, value: value)
                })
            
            // Get the full url from components
            guard let requestURL = urlComponents.url else {
                log.error("Cannot get url from urlComponents")
                throw AppError.invalidEndpoindURL
            }
            
            var request = URLRequest(url: requestURL)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            
            log.info("Built URLRequest for fetchAQIData \(request.debugDescription)")
            
            return request
        }
}
